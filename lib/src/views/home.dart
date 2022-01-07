import 'dart:async';

import 'package:authenticator/application.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../services/otp.dart';
import '../widgets/dialog.dart';
import '../widgets/progress_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late ProgressDialog progressDialogRemove;
  // late Timer timer;
  late int remain_secs;

  late AnimationController _controller;
  late Animation _animation;

  bool isError = false, isloading = true;
  List<Applications> data = [];

  Future<void> getData() async {
    try {
      setState(() {
        isError = false;
        isloading = true;
      });
      data = await sqlDatabase.getAll();
    } catch (e) {
      setState(() => isError = true);
    } finally {
      setState(() => isloading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   setState(() {});
    // });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
      upperBound: 30.0,
      lowerBound: 0.0,
      value: (60.0 - DateTime.now().second) % 30,
    )..animateTo(0.0)
    ..addListener(() {
      if (_controller.value == 0.0) {
        _controller.value = 60.0;
        _controller.animateTo(0.0, duration: const Duration(seconds: 30));
      }
    });
    _animation = Tween(begin: 30.0, end: 0.0).animate(_controller);
    progressDialogRemove = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.normal,
      customBody: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        child: Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 16.0),
            Text('Removing Application...'),
          ],
        ),
      ),
    );
    remain_secs = 60 - DateTime.now().second;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authenticator'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          try {
            await addNewApplication();
            data.clear();
            getData();
          } catch (e) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          data.clear();
          getData();
        },
        child: Builder(
          builder: (context) {
            if (isloading) {
              return const Center(child: CircularProgressIndicator());
            } else if (isError) {
              return errorTextnButton();
            } else if (data.isEmpty) {
              return addApplicationText();
            } else {
              return applicationList();
            }
          },
        ),
      ),
    );
  }

  Widget applicationList() {
    // var time = ((remain_secs - timer.tick) % 30);
    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (_, __) => const Divider(
        indent: 16.0,
        endIndent: 16.0,
        thickness: 1.2,
      ),

      itemBuilder: (_, index) {
        return ListTile(
          minVerticalPadding: 12.0,
          title: Text('${data[index].issuer} (${data[index].user})'),
          subtitle: Text(generateOTP(data[index])),
          trailing: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CircularPercentIndicator(
                animation: true,
                animationDuration: 30000,
                restartAnimation: true,
                circularStrokeCap: CircularStrokeCap.round,
                lineWidth: 4.0,
                radius: 40.0,
                percent: 1.0,
                progressColor: Colors.blue,
                center: Text('${_controller.value.floor()}'),
              );
            },
          ),
          onLongPress: () async {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return actionsMenu(index);
              },
            );
          },
        );
      },
    );
  }

  Widget actionsMenu(int index) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Remove ${data[index].issuer}'),
            onTap: () => deleteDialogConfirm(index),
          ),
          ListTile(
            title: const Text('Go Back'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget addApplicationText() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Add your first application to the authenticator app.'),
      ),
    );
  }

  Widget errorTextnButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Error while loading data...'),
          const SizedBox(height: 20.0),
          OutlinedButton(
            child: const Text('Reload'),
            onPressed: () => getData(),
          ),
        ],
      ),
    );
  }

  void deleteDialogConfirm(int index) {
    Navigator.of(context).pop();
    showConfirmDialog(
      context: context,
      title: 'Remove ${data[index].issuer}',
      content:
          'You\'re about to remove an application from the authenticator. Please remove 2FA from the respective application before proceeding ahead.',
      onAccept: () async {
        Navigator.of(context).pop();
        await progressDialogRemove.show();
        await sqlDatabase.delete(data[index].uid!);
        await progressDialogRemove.hide();
        data.clear();
        getData();
      },
    );
  }
}
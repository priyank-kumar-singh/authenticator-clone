import 'dart:async';

import 'package:authenticator/application.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final ProgressDialog progressDialogRemove;
  late final ProgressDialog progressDialogImport;
  late final AnimationController _controller;

  bool isError = false, isloading = true;
  List<MFA_Apps> data = [];

  Future<void> getData() async {
    try {
      setState(() {
        isError = false;
        isloading = true;
      });
      data = await sqlDatabase.getAll();
      data.sort((a, b) => a.issuer.compareTo(b.issuer));
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
      upperBound: 30.0,
      lowerBound: 1.0,
      value: (60.0 - DateTime.now().second) % 30,
    )..animateTo(1.0)
    ..addListener(() async {
      if (_controller.value == 1.0) {
        _controller.value = 30.0;
        _controller.animateTo(1.0, duration: const Duration(seconds: 30));
        setState(() {});
      }
    });
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
    progressDialogImport = ProgressDialog(
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
            Text('Importing...'),
          ],
        ),
      ),
    );
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
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'add') {
                await Navigator.of(context).pushNamed(Routes.add);
                data.clear();
                getData();
              } else if (value == 'import') {
                await progressDialogImport.show();
                var x = await Scanner.importApps();
                await progressDialogImport.hide();
                if (x) {
                  showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: const Text('Import Successful'),
                    content: const Text('Your applications have been imported successfully'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Continue'),
                      ),
                    ],
                  );
                });
                }
                data.clear();
                getData();
              } else if (value == 'export') {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return ExportScreen(data: data);
                }));
              } else {
                Navigator.of(context).pushNamed(Routes.settings);
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(child: Text('Add Manually'), value: 'add'),
                const PopupMenuItem(child: Text('Import Data'), value: 'import'),
                const PopupMenuItem(child: Text('Export Data'), value: 'export'),
                const PopupMenuItem(child: Text('Settings'), value: 'settings'),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Add MFA Application',
        onPressed: () async {
          try {
            await Scanner.addApplication();
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
    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (_, __) => const Divider(
        indent: 16.0,
        endIndent: 16.0,
        thickness: 1.2,
      ),
      itemBuilder: (_, index) {
        int periodFactor = data[index].period == '30' ? 1 : 2;
        return ListTile(
          minVerticalPadding: 12.0,
          title: Text('${data[index].issuer} (${data[index].user})'),
          subtitle: Text(generateOTP(data[index])),
          trailing: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CircularPercentIndicator(
                circularStrokeCap: CircularStrokeCap.round,
                lineWidth: 4.0,
                radius: 40.0,
                reverse: true,
                animateFromLastPercent: true,
                progressColor: Colors.blue,
                percent: _controller.value / (3 * periodFactor) * 0.1,
                center: Text('${(_controller.value * periodFactor).floor()}'),
              );
            },
          ),
          onLongPress: () async {
            await showDialog(
              context: context,
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

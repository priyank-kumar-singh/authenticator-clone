import 'package:flutter/material.dart';
import 'package:authenticator/application.dart';

// ignore: use_key_in_widget_constructors
class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  void initTools() async {
    sqlDatabase = await SQLDatabase.getInstance();
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  @override
  void initState() {
    super.initState();
    initTools();
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

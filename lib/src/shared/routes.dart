import 'package:authenticator/src/views/manual_add.dart';
import 'package:flutter/widgets.dart';
import 'package:authenticator/application.dart';

class Routes {
  Routes._();

  static const wrapper = '/';
  static const home = '/home';
  static const add = '/add';
  static const settings = '/settings';
  static const tnc = '/terms';

  static Map<String, WidgetBuilder> routes = {
    wrapper: (_) => Wrapper(),
    home: (_) => const HomeScreen(),
    add: (_) => const NewMFAAppManually(),
    settings: (_) => const SettingsScreen(),
    tnc: (_) => TnCScreen(),
  };
}

import 'package:flutter/widgets.dart';
import 'package:authenticator/application.dart';

class Routes {
  Routes._();

  static const wrapper = '/';
  static const home = '/home';
  static const tnc = '/terms';

  static Map<String, WidgetBuilder> routes = {
    wrapper: (_) => Wrapper(),
    home: (_) => const HomeScreen(),
    tnc: (_) => TnCScreen(),
  };
}

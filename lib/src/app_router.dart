import 'package:flutter/material.dart';
import 'package:zotit/src/screens/home/home.dart';
import 'package:zotit/src/screens/login/login.dart';
import 'package:zotit/src/screens/register/register.dart';

import '../main.dart';

class AppRoutes {
  static const startupPage = '/startup-page';
  static const homePage = '/home';
  static const loginPage = '/login';
  static const registerPage = '/register';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.startupPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const StartupPage(),
          settings: settings,
        );
      case AppRoutes.homePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => Home(),
          settings: settings,
        );
      case AppRoutes.loginPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const Login(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.registerPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const Register(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}

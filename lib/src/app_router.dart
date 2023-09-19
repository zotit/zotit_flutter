import 'package:flutter/material.dart';
import 'package:zotit/src/screens/delete_account/delete_account.dart';
import 'package:zotit/src/screens/home/home.dart';
import 'package:zotit/src/screens/login/login.dart';
import 'package:zotit/src/screens/register/register.dart';
import 'package:zotit/src/screens/tags/note_tags.dart';
import 'package:zotit/src/screens/update_profile/update_profile.dart';

import '../main.dart';

class AppRoutes {
  static const startupPage = '/startup-page';
  static const homePage = '/home';
  static const searchPage = '/search';
  static const updateProfile = '/update-profile';
  static const tagList = '/tag-list';
  static const deleteAccount = '/delete-account';
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
          builder: (_) => const Home(),
          settings: settings,
        );
      case AppRoutes.tagList:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const NoteTags(),
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
      case AppRoutes.updateProfile:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const UpdateProfile(),
          settings: settings,
        );
      case AppRoutes.deleteAccount:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const DeleteAccount(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}

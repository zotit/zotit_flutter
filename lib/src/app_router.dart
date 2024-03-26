import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';
import 'package:zotit/src/screens/common/error_page.dart';
import 'package:zotit/src/screens/delete_account/delete_account.dart';
import 'package:zotit/src/screens/forgotpw/forgotpw.dart';
import 'package:zotit/src/screens/home/deleted_notes.dart';
import 'package:zotit/src/screens/home/home.dart';
import 'package:zotit/src/screens/login/login.dart';
import 'package:zotit/src/screens/register/register.dart';
import 'package:zotit/src/screens/tags/note_tags.dart';
import 'package:zotit/src/screens/update_profile/update_profile.dart';
import 'package:zotit/src/screens/resetpw/resetpw.dart';

class AppRoutes {
  static const startupPage = '/';
  static const homePage = '/home';
  static const deletedNotesPage = '/deleted-notes';
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
      case AppRoutes.deletedNotesPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const DeletedNotes(),
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
          builder: (_) => UpdateProfile(),
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

class StartupPage extends ConsumerWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginData = ref.watch(loginTokenProvider);
    return loginData.when(
      data: (user) {
        if (user.username != "") {
          return const Home();
        } else {
          if (user.page == 'resetpw') {
            return const Resetpw();
          }
          if (user.page == 'register') {
            return const Register();
          }
          if (user.page == 'forgotpw') {
            return const Forgotpw();
          }

          return const Login();
        }
      },
      loading: () => Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, st) => ErrorPage(message: st.toString()),
    );
  }
}

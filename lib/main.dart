import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zotit/src/app_router.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';
import 'package:zotit/src/screens/common/error_page.dart';
import 'package:zotit/src/screens/forgotpw/forgotpw.dart';
import 'package:zotit/src/screens/home/home.dart';
import 'package:zotit/src/screens/login/login.dart';
import 'package:zotit/src/screens/register/register.dart';
import 'package:zotit/src/screens/resetpw/resetpw.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZotIt : Note anywhere',
      theme: ThemeData(
        // UI
        brightness: Brightness.light,

        // font
        fontFamily: GoogleFonts.notoSans().fontFamily,
        //text style
        textTheme: const TextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3A568E),
          foregroundColor: Color(0xFFFFFFFF),
        ),
        drawerTheme: const DrawerThemeData(shape: BeveledRectangleBorder()),
        cardTheme: const CardTheme(color: Colors.white),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStatePropertyAll(
              Color(0xFF3A568E),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            foregroundColor: Colors.white, shape: CircleBorder()),
      ),
      debugShowCheckedModeBanner: false,
      // home: const StartupPage(),
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
      home: const StartupPage(),
    );
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
          if (user.page == 'resetpw') {
            return const Resetpw();
          }
          return const Home();
        } else {
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
      error: (error, st) => ErrorPage(message: error.toString()),
    );
  }
}

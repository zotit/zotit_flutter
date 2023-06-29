import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zotit_flutter/src/app_router.dart';
import 'package:zotit_flutter/src/providers/login_provider/login_provider.dart';
import 'package:zotit_flutter/src/screens/common/error_page.dart';
import 'package:zotit_flutter/src/screens/home/home.dart';
import 'package:zotit_flutter/src/screens/login/login.dart';
import 'package:zotit_flutter/src/screens/register/register.dart';

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
        // fontFamily: 'Georgia',
        //text style
        textTheme: const TextTheme(),
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
        if (user.token != "") {
          return Home();
        } else {
          if (user.page == 'register') {
            return const Register();
          }
          return const Login();
        }
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, st) => ErrorPage(message: error.toString() + st.toString()),
    );
  }
}

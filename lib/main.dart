import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zotit/src/app_router.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';
import 'package:zotit/src/providers/theme_provider/darkmode_provider.dart';
import 'package:zotit/src/screens/common/error_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);
    final themeData = ThemeData(
        // UI
        brightness:
            darkMode.value == false ? Brightness.dark : Brightness.light,
        // font
        fontFamily: GoogleFonts.notoSans().fontFamily,
        //text style
        textTheme: const TextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: darkMode.value == true
              ? const Color(0xFF3A568E)
              : const Color(0xFF585659),
          foregroundColor: const Color(0xFFFFFFFF),
        ),
        iconTheme: IconThemeData(
          color: darkMode.value == true
              ? const Color(0xFFAAAAAA)
              : const Color(0xFF3A568E),
        ),
        switchTheme: SwitchThemeData(
          thumbIcon: darkMode.value == true
              ? const MaterialStatePropertyAll(Icon(Icons.light_mode))
              : const MaterialStatePropertyAll(Icon(Icons.dark_mode)),
        ),
        scaffoldBackgroundColor:
            darkMode.value == true ? Colors.white : const Color(0xFF272526),
        popupMenuTheme: PopupMenuThemeData(
            iconColor: darkMode.value == true
                ? const Color(0xFF3A568E)
                : const Color.fromARGB(255, 195, 195, 195)),
        drawerTheme: const DrawerThemeData(shape: BeveledRectangleBorder()),
        cardTheme: CardTheme(
            color: darkMode.value == true
                ? Colors.white
                : const Color(0xFF373737)),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
          foregroundColor: darkMode.value == true
              ? MaterialStateProperty.all<Color>(const Color(0xFF3A568E))
              : MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 195, 195, 195)),
        )),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
          iconColor: const MaterialStatePropertyAll(Colors.white),
          textStyle: MaterialStatePropertyAll(
            TextStyle(
                color: darkMode.value == true
                    ? Colors.white
                    : const Color.fromARGB(255, 68, 72, 74)),
          ),
        )),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 4),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStatePropertyAll(
              Color(0xFF3A568E),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: darkMode.value == true
              ? const Color(0xFF3A568E)
              : const Color(0xFF3a3a3a),
          shape: const CircleBorder(),
        ),
        outlinedButtonTheme: const OutlinedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 4),
            ),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                side: BorderSide(
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color:
              darkMode.value == true ? const Color(0xFF3A568E) : Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
              color: darkMode.value == true
                  ? const Color(0xFF3A568E)
                  : Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: darkMode.value == true
                    ? const Color(0xFF3A568E)
                    : Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: darkMode.value == true
                    ? const Color(0xFF3A568E)
                    : Colors.white),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: darkMode.value == true
                ? const Color(0xFF3A568E)
                : Colors.white));

    final loginData = ref.watch(loginTokenProvider);
    return loginData.when(
        data: (user) {
          if (user.username != "") {
            return MaterialApp(
              title: 'ZotIt : Note anywhere',
              themeMode:
                  darkMode.value == true ? ThemeMode.dark : ThemeMode.light,
              theme: themeData,

              debugShowCheckedModeBanner: false,
              // home: const StartupPage(),
              onGenerateRoute: (settings) =>
                  AppRouter.onGenerateRoute(settings, user),
              home: null,
            );
          } else {
            return MaterialApp(
              title: 'ZotIt : Note anywhere',
              themeMode:
                  darkMode.value == true ? ThemeMode.dark : ThemeMode.light,
              theme: themeData,
              debugShowCheckedModeBanner: false,
              home: StartupPage(),
            );
          }
        },
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, st) => ErrorPage(message: st.toString()));
  }
}

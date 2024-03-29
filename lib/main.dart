import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zotit/src/app_router.dart';
import 'package:zotit/src/providers/theme_provider/darkmode_provider.dart';

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
    return MaterialApp(
      title: 'ZotIt : Note anywhere',
      themeMode: darkMode.value == true ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        // UI
        brightness:
            darkMode.value == false ? Brightness.dark : Brightness.light,
        // font
        fontFamily: GoogleFonts.notoSans().fontFamily,
        //text style
        textTheme: const TextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3A568E),
          foregroundColor: Color(0xFFFFFFFF),
        ),
        iconTheme: IconThemeData(
          color: darkMode.value == true
              ? const Color.fromARGB(255, 195, 195, 195)
              : const Color(0xFF3A568E),
        ),
        switchTheme: SwitchThemeData(
          thumbIcon: darkMode.value == true
              ? const MaterialStatePropertyAll(Icon(Icons.light_mode))
              : const MaterialStatePropertyAll(Icon(Icons.dark_mode)),
        ),
        scaffoldBackgroundColor: darkMode.value == true
            ? Colors.white
            : const Color.fromARGB(255, 97, 97, 97),
        popupMenuTheme: PopupMenuThemeData(
            iconColor: darkMode.value == true
                ? const Color(0xFF3A568E)
                : const Color.fromARGB(255, 195, 195, 195)),
        drawerTheme: const DrawerThemeData(shape: BeveledRectangleBorder()),
        cardTheme: CardTheme(
            color: darkMode.value == true
                ? Colors.white
                : const Color.fromARGB(255, 68, 72, 74)),

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
      home: null,
    );
  }
}

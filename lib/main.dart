import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zotit/src/app_router.dart';
import 'package:zotit/src/providers/login_provider/login_provider.dart';
import 'package:zotit/src/providers/theme_provider/apptheme_data_provider.dart';
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
    final appThemeData = ref.watch(appThemeDataProvider);
    final themeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3A568E),
        brightness: appThemeData.value?.isDarkMode == null
            ? MediaQuery.platformBrightnessOf(context)
            : appThemeData.value?.isDarkMode == true
                ? Brightness.light
                : Brightness.dark,
      ),
      // font
      fontFamily: GoogleFonts.notoSans().fontFamily,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: appThemeData.value?.isDarkMode == true
            ? const Color(0xFF3A568E)
            : const Color(0xFF1F2937),
        foregroundColor: Colors.white,
        elevation: 2,
      ),

      // Card theme
      cardTheme: CardTheme(
        color: appThemeData.value?.isDarkMode == true
            ? Colors.white
            : const Color(0xFF1F2937),
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Icon themes
      iconTheme: IconThemeData(
        color: appThemeData.value?.isDarkMode == true
            ? const Color(0xFF3A568E)
            : Colors.white70,
        size: 24,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return appThemeData.value?.isDarkMode == true
                ? const Color(0xFF3A568E)
                : Colors.white;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return appThemeData.value?.isDarkMode == true
                ? const Color(0xFF3A568E).withOpacity(0.5)
                : Colors.white70;
          }
          return null;
        }),
        thumbIcon: appThemeData.value?.isDarkMode == true
            ? const MaterialStatePropertyAll(Icon(Icons.light_mode))
            : const MaterialStatePropertyAll(Icon(Icons.dark_mode)),
      ),

      // Scaffold background
      scaffoldBackgroundColor: appThemeData.value?.isDarkMode == true
          ? const Color(0xFFF8FAFC) // Light gray for light mode
          : const Color(0xFF111827), // Dark gray for dark mode

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(
            appThemeData.value?.isDarkMode == true
                ? const Color(0xFF3A568E)
                : Colors.white70,
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          textStyle: MaterialStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),

      // Icon button theme
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(
            appThemeData.value?.isDarkMode == true
                ? const Color(0xFF3A568E)
                : Colors.white70,
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(8),
          ),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF3A568E)),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appThemeData.value?.isDarkMode == true
            ? Colors.grey[100]
            : const Color(0xFF1F2937),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: appThemeData.value?.isDarkMode == true
                ? const Color(0xFF3A568E)
                : Colors.white70,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: appThemeData.value?.isDarkMode == true
                ? const Color(0xFF3A568E).withOpacity(0.5)
                : Colors.white24,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: appThemeData.value?.isDarkMode == true
                ? const Color(0xFF3A568E)
                : Colors.white,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: appThemeData.value?.isDarkMode == true
              ? const Color(0xFF3A568E)
              : Colors.white70,
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: appThemeData.value?.isDarkMode == true
            ? Colors.grey[300]
            : Colors.white24,
        thickness: 1,
      ),

      // Popup menu theme
      popupMenuTheme: PopupMenuThemeData(
        color: appThemeData.value?.isDarkMode == true
            ? Colors.white
            : const Color(0xFF1F2937),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    final loginData = ref.watch(loginTokenProvider);
    return loginData.when(
        data: (user) {
          if (user.username != "") {
            return MaterialApp(
              title: 'ZotIt : Note anywhere',
              themeMode: appThemeData.value?.isDarkMode == null
                  ? ThemeMode.system
                  : appThemeData.value?.isDarkMode == true
                      ? ThemeMode.dark
                      : ThemeMode.light,
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
              themeMode: appThemeData.value?.isDarkMode == null
                  ? ThemeMode.system
                  : appThemeData.value?.isDarkMode == true
                      ? ThemeMode.dark
                      : ThemeMode.light,
              theme: themeData,
              debugShowCheckedModeBanner: false,
              home: StartupPage(),
            );
          }
        },
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, st) => ErrorPage(message: error.toString()));
  }
}

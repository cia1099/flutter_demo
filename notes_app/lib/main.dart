import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/app_colors.dart';
import 'package:notes_app/views/landing_view.dart';
import 'package:provider/provider.dart';

import 'model/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      builder: (context) => Provider(
        create: ((context) => <Note>[]),
        child: MaterialApp(
          title: 'Notes App',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
              appBarTheme: const AppBarTheme(
                  actionsIconTheme:
                      IconThemeData(color: AppColors.lightTextColor),
                  centerTitle: false,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: AppColors.buttonColor),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.lightTextColor)),
              tabBarTheme: const TabBarTheme(
                  indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(width: 3, color: AppColors.orange)),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: AppColors.orange),
              fontFamily: GoogleFonts.poppins().fontFamily,
              backgroundColor: AppColors.containerBackground,
              scaffoldBackgroundColor: AppColors.scaffoldBackground,
              brightness: Brightness.dark,
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      backgroundColor: AppColors.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))))),
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const LandingView(),
        ),
      ),
      maximumSize: const Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey,
    );
  }
}

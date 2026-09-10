import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Color(0xffF1EFEA),
    textTheme: TextTheme(titleLarge: TextStyle(color: Colors.black),),
    appBarTheme: AppBarTheme(backgroundColor: Color(0xffF9F8F6),),
    cardTheme: CardThemeData(color: Colors.white,shadowColor: const Color(0xffF1EFEA)),
    cardColor: Colors.grey[100],
    iconTheme: IconThemeData(color: Colors.black54),
    shadowColor:Colors.blueAccent.withValues(alpha: 0.3),
    textSelectionTheme: TextSelectionThemeData(selectionHandleColor: Colors.black)
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Color(0xff171717),
    textTheme: TextTheme(titleLarge: TextStyle(color: Colors.white)),
    appBarTheme: AppBarTheme(backgroundColor: Color(0xff212121),),
    cardTheme: CardThemeData(color: Color(0xff2B2B2B),shadowColor: const Color(0xff2E2E2E)),
    cardColor: Color(0xff292929),
    iconTheme: IconThemeData(color: Colors.white54.withValues(alpha: 0.7)),
    shadowColor: Colors.lightBlueAccent,
    textSelectionTheme: TextSelectionThemeData(selectionHandleColor: Colors.white.withValues(alpha: 0.2))
  );
}
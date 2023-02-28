import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryColor = const Color(0xff7190FF);

//Fontsizes
double xsmall = 13.0;
double small = 14.0;
double medium = 15.0;
double large = 17.0;
double xlarge = 18.0;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
);

ThemeData themeData = ThemeData(
  primaryColor: primaryColor,
  appBarTheme: AppBarTheme(backgroundColor: primaryColor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(primaryColor),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(primaryColor),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(primaryColor),
    ),
  ),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: primaryColor),
  bottomNavigationBarTheme:
      BottomNavigationBarThemeData(selectedItemColor: primaryColor),
  textTheme: GoogleFonts.poppinsTextTheme(),
);

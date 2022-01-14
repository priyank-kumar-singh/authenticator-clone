import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: GoogleFonts.poppins().fontFamily,
  ),
  primaryTextTheme: ThemeData.dark().textTheme.apply(
    fontFamily: GoogleFonts.poppins().fontFamily,
  ),

  appBarTheme: AppBarTheme(
    toolbarTextStyle: TextTheme(
      bodyText2: TextStyle(
        fontSize: 20.0,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
      ),
    ).bodyText2,
    titleTextStyle: TextTheme(
      headline6: TextStyle(
        fontSize: 20.0,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
      ),
    ).headline6,
  ),

  dividerTheme: DividerThemeData(
    color: Colors.grey.shade600,
  ),

  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
    filled: true,
    fillColor: Color(0xFFEEEEEE),
  ),

  snackBarTheme: const SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    actionTextColor: Colors.purple,
  ),
);

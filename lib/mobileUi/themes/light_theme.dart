import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  accentColor: Colors.lightBlue,
  appBarTheme: AppBarTheme(centerTitle: true, titleTextStyle: TextStyle()),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
    size: 20,
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: TextStyle(color: Colors.white),
    backgroundColor: Colors.black,
    actionTextColor: Colors.white,
  ),
  colorScheme: ColorScheme(
    primary: Colors.black,
    onPrimary: ThemeData.dark().scaffoldBackgroundColor,
    primaryVariant: Colors.black,
    secondary: Colors.green,
    onSecondary: Colors.green,
    secondaryVariant: Colors.green,
    error: Colors.red,
    onError: Colors.red,
    background: Colors.blue,
    onBackground: Colors.blue,
    surface: Colors.white,
    onSurface: Colors.white,
    brightness: Brightness.light,
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    labelStyle: TextStyle(color: Colors.black),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  ),
);

import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(
  appBarTheme: AppBarTheme(centerTitle: true, titleTextStyle: TextStyle()),
  accentColor: Colors.lightBlue,
  colorScheme: ColorScheme(
    primary: Colors.white,
    onPrimary: Colors.white,
    primaryVariant: Colors.white,
    secondary: Colors.green,
    onSecondary: Colors.green,
    secondaryVariant: Colors.green,
    error: Colors.red,
    onError: Colors.red,
    background: Colors.blue,
    onBackground: Colors.blue,
    surface: Colors.black,
    onSurface: Colors.black,
    brightness: Brightness.dark,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.black,
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
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    labelStyle: TextStyle(color: Colors.white),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  ),
);

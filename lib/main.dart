import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/mobileUi/concrete/interface/category_add_screen/category_add_screen.dart';
import 'package:flutter_meal_app_update/mobileUi/concrete/interface/category_list_screen/category_list_screen.dart';
import 'package:flutter_meal_app_update/mobileUi/concrete/interface/recipe_add_screen/recipe_add_screen.dart';
import 'package:flutter_meal_app_update/mobileUi/concrete/interface/recipe_list_screen/recipe_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Meal App",
      initialRoute: "/",
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(centerTitle: true),
        accentColor: Colors.black,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => new RecipeListScreen(),
        "/categoryAdd": (context) => new CategoryAddScreen(),
        "/categoryList": (context) => new CategoryListScreen(),
        "/recipeAdd": (context) => new RecipeAddScreen(),
      },
    );
  }
}

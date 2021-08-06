import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/mobileUi/interface/download_screens/download_video_screen.dart';
import 'package:flutter_meal_app_update/mobileUi/interface/play_on_youtube/play_on_youtube_screen.dart';
import 'package:flutter_meal_app_update/mobileUi/interface/recipe_detail_screen/recipe_detail_screen.dart';

import 'package:provider/provider.dart';

import 'package:flutter_meal_app_update/data/concrete/managers/local_preferences_manager.dart';
import 'package:flutter_meal_app_update/data/concrete/providers/theme_provider.dart';
import 'package:flutter_meal_app_update/mobileUi/interface/category_add_screen/category_add_screen.dart';
import 'package:flutter_meal_app_update/mobileUi/interface/category_list_screen/category_list_screen.dart';
import 'package:flutter_meal_app_update/mobileUi/interface/recipe_add_screen/recipe_add_screen.dart';
import 'package:flutter_meal_app_update/mobileUi/interface/recipe_list_screen/recipe_list_screen.dart';
import 'package:flutter_meal_app_update/mobileUi/interface/settings_screen/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([]);
  await LocalPreferencesManager.prefenecesInit();
  LocalPreferencesManager.initApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Meal App",
      initialRoute: "/",
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => new RecipeListScreen(),
        "/categoryAdd": (context) => new CategoryAddScreen(),
        "/categoryList": (context) => new CategoryListScreen(),
        "/recipeAdd": (context) => new RecipeAddScreen(),
        "/settings": (context) => new SettingsScreen(),
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route _getRoute(RouteSettings settings) {
    if (settings.name == "/downloadVideo") {
      return _routeBuilder(
        DownloadVideoScreen(settings.arguments),
      );
    } else if (settings.name == "/recipeDetail") {
      return _routeBuilder(RecipeDetailScreen(
        recipe: settings.arguments,
      ));
    } else if (settings.name == "/playOnYoutube") {
      return _routeBuilder(PlayOnYoutubeScreen(
        recipe: settings.arguments,
      ));
    }
    return null;
  }

  Route _routeBuilder(Widget widget) {
    return new MaterialPageRoute(builder: (context) => widget);
  }
}

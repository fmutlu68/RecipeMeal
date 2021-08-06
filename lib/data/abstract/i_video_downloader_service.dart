import 'package:flutter_meal_app_update/models/concrete/recipe.dart';

abstract class IVideoDownloaderService {
  void downloadVideo(Recipe recipe);
  void downloadAudio(Recipe recipe);
  Future<Recipe> getRecipeIngredients(Recipe recipe);
  Future<String> getVideoImage(String recipeLink);
}

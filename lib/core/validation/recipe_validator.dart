import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/core/widgets/snack_bar_manager.dart';

class RecipeValidationMixin {
  String validateName(String name) {
    if (name == null || name.length < 2) {
      return "En Az 2 Karakter";
    }
  }

  String validateIngredients(String ingredients) {
    if (ingredients.length > 0 && ingredients.length < 2) {
      return "En Az 2 Karakter";
    }
  }

  String validateYoutubeLink(String youtubeLink) {
    if (youtubeLink.length > 0) {
      if (youtubeLink.startsWith("https://youtu.be") == false) {
        return "Link Youtubedan Olmalıdır.";
      }
    }
  }

  String validateImage(String image64) {
    if (image64 == null || image64.length < 50) {
      return "Bir Resim Eklenmelidir.";
    }
  }

  String validateCategory(int categoryId) {
    if (categoryId == null || categoryId < 0) {
      return "Bir Kategori Seçilmelidir.";
    }
    return null;
  }

  void showValidationError(
    BuildContext context,
    String message, {
    var onPressed,
  }) {
    SnackBarManager.showErrorSnackBar(
      Text(message),
      context: context,
      onPressed: onPressed,
    );
  }
}

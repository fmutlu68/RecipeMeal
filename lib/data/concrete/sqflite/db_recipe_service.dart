import 'package:flutter_meal_app_update/core/constants/messages.dart';
import 'package:flutter_meal_app_update/core/utilities/results/error_data_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/error_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/success_data_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/success_result.dart';
import 'package:flutter_meal_app_update/data/abstract/i_recipe_service.dart';
import 'package:flutter_meal_app_update/data/concrete/sqflite/db_helper.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';

class DbRecipeService implements IRecipeService {
  static DbHelper _dbHelper = new DbHelper();
  static DbRecipeService _singleton = new DbRecipeService._internal();

  factory DbRecipeService() {
    return _singleton;
  }
  DbRecipeService._internal();

  static Future<IResult> add(Recipe entity) async {
    IResult result;
    try {
      var addedResult =
          await (await _dbHelper.db).insert("recipes", entity.convertToMap());
      if (addedResult > 0) {
        result = new SuccessResult.withMessage(Messages.recipeAddedSucceed);
      } else {
        result = new ErrorResult.withMessage(Messages.recipeAddedUnsucceed);
      }
    } catch (error) {
      result =
          new ErrorResult.withMessage("Bir Hata Oluştu: ${error.toString()}");
    }
    return result;
  }

  static Future<IResult> delete(Recipe entity) async {
    IResult result;
    try {
      int deletedResult = await (await _dbHelper.db)
          .rawDelete("delete from recipes where id=${entity.id}");
      if (deletedResult > 0)
        result = SuccessResult.withMessage(Messages.recipeDeletedSucceed);
      else
        result = ErrorResult.withMessage(Messages.recipeDeletedUnsucceed);
    } catch (error) {
      result = ErrorResult.withMessage("Bir Hata Oluştu: ${error.toString()}");
    }
    return result;
  }

  static Future<IDataResult<List<Recipe>>> getAll() async {
    try {
      var recipes = await (await _dbHelper.db).query("recipes");
      List<Recipe> createdRecipes = List.generate(recipes.length, (index) {
        return new Recipe.fromData(recipes[index]);
      });
      return new SuccessDataResult(
          Messages.recipeListedSucceed, createdRecipes);
    } catch (error) {
      return ErrorDataResult.onlyMessage(Messages.recipeListedUnsucceed);
    }
  }

  static Future<IDataResult<List<Recipe>>> getAllByCategoryId(
      int categoryId) async {
    IDataResult<List<Recipe>> result;
    try {
      var recipes = (await (await _dbHelper.db).query("recipes"))
          .where((element) => element["category_id"] == categoryId)
          .toList();
      List<Recipe> createdRecipes = List.generate(recipes.length, (index) {
        return new Recipe.fromData(recipes[index]);
      });
      result = new SuccessDataResult(
          Messages.recipeListedByCategoryIdSucceed, createdRecipes);
    } catch (error) {
      result = ErrorDataResult.onlyMessage(
          Messages.recipeListedByCategoryIdUnsucceed);
    }
    return result;
  }

  static Future<IDataResult<Recipe>> getById(int id) async {
    IDataResult<Recipe> result;
    try {
      var recipe = (await (await _dbHelper.db).query("recipes"))
          .firstWhere((element) => element["id"] == id);
      Recipe convertedRecipe = Recipe.fromData(recipe);
      result =
          new SuccessDataResult(Messages.recipeGetSucceed, convertedRecipe);
    } catch (error) {
      result = ErrorDataResult.onlyMessage(Messages.recipeGetUnsucceed);
    }
    return result;
  }

  static Future<IResult> update(Recipe entity) async {
    IResult result;
    try {
      var updatedResult = await (await _dbHelper.db).update(
          "recipes", entity.convertToMap(),
          where: "id=?", whereArgs: [entity.id]);
      if (updatedResult > 0) {
        result = new SuccessResult.withMessage(Messages.recipeUpdatedSucceed);
      } else {
        result = new ErrorResult.withMessage(Messages.recipeUpdatedUnsucceed);
      }
    } catch (error) {
      result =
          new ErrorResult.withMessage("Bir Hata Oluştu: ${error.toString()}");
    }
    return result;
  }
}

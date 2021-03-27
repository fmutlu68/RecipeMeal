import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';
import 'package:flutter_meal_app_update/data/abstract/i_service.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';

abstract class IRecipeService implements IService<Recipe> {
  static Future<IDataResult<List<Recipe>>> getAllByCategoryId(
      int categoryId) async {}
}

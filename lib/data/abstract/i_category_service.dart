import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';
import 'package:flutter_meal_app_update/data/abstract/i_service.dart';
import 'package:flutter_meal_app_update/models/concrete/category.dart';

abstract class ICategoryService implements IService<Category> {
  static Future<IDataResult<Category>> getCategoryById(int id) {}
}

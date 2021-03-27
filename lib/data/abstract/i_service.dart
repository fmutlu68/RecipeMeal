import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_result.dart';

abstract class IService<T> {
  // ignore: missing_return
  static Future<IResult> add<T>(T entity) {}
  // re: missing_return
  static Future<IResult> delete<T>(T entity) {}
  // re: missing_return
  static Future<IResult> update<T>(T entity) {}
  // re: missing_return
  static Future<IDataResult<List<T>>> getAll<T>() {}
  // re: missing_return
  static Future<IDataResult<T>> getById<T>(int id) {}
}

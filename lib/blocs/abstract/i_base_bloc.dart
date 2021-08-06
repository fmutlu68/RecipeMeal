import 'package:flutter_meal_app_update/core/utilities/results/i_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';

abstract class IBaseBloc<T> {
  Future<IResult> add(T entity);
  Future<IResult> delete(T entity);
  Future<IResult> update(T entity);
  Future<IDataResult<List<T>>> getAll();
  Future<IDataResult<T>> getById(int id);
}

import 'package:flutter_meal_app_update/core/utilities/results/data_result.dart';

class ErrorDataResult<T> extends DataResult<T> {
  ErrorDataResult(String message, T newData) : super(false, message, newData);
  ErrorDataResult.onlyMessage(String message) : super(false, message, null);
  ErrorDataResult.empty() : super.withSuccess(false, null);
  ErrorDataResult.onlyData(T newData) : super.withSuccess(false, newData);
}
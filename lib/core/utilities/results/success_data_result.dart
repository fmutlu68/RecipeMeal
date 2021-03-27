import 'package:flutter_meal_app_update/core/utilities/results/data_result.dart';

class SuccessDataResult<T> extends DataResult<T> {
  SuccessDataResult(String message, T newData) : super(true, message, newData);
  SuccessDataResult.onlyMessage(String message) : super(true, message, null);
  SuccessDataResult.empty() : super.withSuccess(true, null);
  SuccessDataResult.onlyData(T newData) : super.withSuccess(true, newData);
}

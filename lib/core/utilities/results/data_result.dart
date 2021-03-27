import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/result.dart';

class DataResult<T> extends Result implements IDataResult<T> {
  T data;

  DataResult(bool isSuccess, String message, T newData)
      : super(isSuccess, message) {
    this.message = message;
    data = newData;
  }
  DataResult.withSuccess(bool isSuccess, T newData)
      : super.onlySuccess(isSuccess) {
    data = newData;
  }
}

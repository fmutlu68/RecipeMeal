import 'package:flutter_meal_app_update/core/utilities/results/i_result.dart';

class Result implements IResult {
  @override
  bool isSuccess;

  @override
  String message;

  Result(this.isSuccess, this.message);
  Result.onlySuccess(this.isSuccess);
}

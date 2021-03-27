import 'package:flutter_meal_app_update/core/utilities/results/result.dart';

class SuccessResult extends Result {
  SuccessResult() : super.onlySuccess(true);
  SuccessResult.withMessage(String message) : super(true, message);
}

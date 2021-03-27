import 'package:flutter_meal_app_update/core/utilities/results/result.dart';

class ErrorResult extends Result {
  ErrorResult() : super.onlySuccess(false);
  ErrorResult.withMessage(String message) : super(false, message);
}

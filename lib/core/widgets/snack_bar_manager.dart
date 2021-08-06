import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/core/extensions/duration_extension.dart';

class SnackBarManager {
  static void showSuccessSnackBar(
    Widget _content, {
    String actionLabel = "Tamam",
    BuildContext context,
    DurationLevel duration = DurationLevel.NORMAL,
    var onPressed,
  }) {
    var snackBar = new SnackBar(
      content: _content,
      action: SnackBarAction(
        label: actionLabel,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          if (onPressed != null) {
            onPressed.call();
          }
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      behavior: SnackBarBehavior.fixed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      duration: duration.duration,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showErrorSnackBar(
    Widget _content, {
    String actionLabel = "Tamam",
    BuildContext context,
    DurationLevel duration = DurationLevel.NORMAL,
    var onPressed,
  }) {
    var snackBar = new SnackBar(
      content: _content,
      action: SnackBarAction(
        label: actionLabel,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          if (onPressed != null) {
            onPressed.call();
          }
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.fixed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      duration: duration.duration,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

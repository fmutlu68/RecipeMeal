import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/core/extensions/device_size_extension.dart';

class BottomSheetManager {
  static void showBottomSheet(
    BuildContext context, {
    bool isDismissable = true,
    double percentage = 18,
    List<Widget> children,
  }) {
    if (children == null) {
      children = [];
    }
    List<Widget> widgets = [
      _bottomSheetDivider(context),
    ];
    widgets.addAll(children);
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissable,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) => Container(
        height: context.calculateByPercentage(percentage, SideTypes.VERTICAL),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets,
        ),
      ),
    );
  }

  static Widget _bottomSheetDivider(BuildContext context) => Divider(
        color: Theme.of(context).colorScheme.primary,
        indent: context.calculateByPercentage(40, SideTypes.HORIZONTAL),
        thickness: context.calculateByPercentage(1, SideTypes.HORIZONTAL),
        endIndent: context.calculateByPercentage(40, SideTypes.HORIZONTAL),
      );
}

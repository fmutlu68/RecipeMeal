import 'package:flutter/material.dart';

enum SideTypes { VERTICAL, HORIZONTAL }

extension DeviceSizeExtension on BuildContext {
  Size get deviceSize => MediaQuery.of(this).size;
  double get deviceHeight => deviceSize.height;
  double get deviceWidth => deviceSize.width;

  double calculateByPercentage(double percentage, SideTypes currentSide) {
    if (currentSide == SideTypes.VERTICAL) {
      return this.deviceHeight * (percentage / 100);
    } else {
      return this.deviceWidth * (percentage / 100);
    }
  }
}

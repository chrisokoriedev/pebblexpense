import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPadding {
  static EdgeInsets get pageHorizontal => EdgeInsets.symmetric(horizontal: 24.w);
  static EdgeInsets get pageVertical => EdgeInsets.symmetric(vertical: 24.h);
  static EdgeInsets get pageAll => EdgeInsets.all(24.w);
  
  static EdgeInsets get cardInner => EdgeInsets.all(32.w);
  static EdgeInsets get itemSymmetric => EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h);
  static EdgeInsets get smallSymmetric => EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h);
  
  static EdgeInsets get listHeader => EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h);
  static EdgeInsets get inputSymmetric => EdgeInsets.symmetric(horizontal: 40.w);
  static EdgeInsets get bottomNavVertical => EdgeInsets.symmetric(vertical: 16.h);
}

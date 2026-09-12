import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  static const List<int> quickAmounts = [500, 1000, 5000, 10000, 15000];
  static const List<String> categories = ['Food', 'Transport', 'Bills', 'Other'];
  static const String defaultCategory = 'Other';
  
  static double get cardRadius => 24.r;
  static double get buttonRadius => 100.r;
  static double get containerRadius => 16.r;
  static double get avatarRadius => 20.r;
  static double get actionAvatarRadius => 28.r;
  static double get listItemAvatarRadius => 24.r;
  static double get bottomNavRadius => 32.r;
}

import 'package:flutter/material.dart';
import 'package:voice_gpt/common/colors.dart';

class TAppTheme {
  // don't want user call the theme through the instance
  // so we make it private
  TAppTheme._();

  static ThemeData lightTheme =
      ThemeData(brightness: Brightness.light, primaryColor: tPrimaryColor);
  static ThemeData darkTheme =
      ThemeData(brightness: Brightness.dark, primaryColor: tPrimaryColor);
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  var mode = GetStorage();
  var isDark = GetStorage().read('mode');
  void updateTheme(value) {
    isDark = value;
    if (value == false) {
      Get.changeThemeMode(ThemeMode.light);
      Get.changeTheme(ThemeData.light());
      mode.write("mode", value);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      Get.changeTheme(ThemeData.dark());
      mode.write("mode", value);
    }
    update();
  }
}

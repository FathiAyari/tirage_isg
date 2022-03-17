import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  var mode = GetStorage();

  void updateTheme(value) {
    if (value == false) {
      Get.changeThemeMode(ThemeMode.light);
      Get.changeTheme(ThemeData.light());
      mode.write("mode", value);
    } else {
      update();
      Get.changeThemeMode(ThemeMode.dark);
      Get.changeTheme(ThemeData.dark());
      mode.write("mode", value);
    }
  }
}

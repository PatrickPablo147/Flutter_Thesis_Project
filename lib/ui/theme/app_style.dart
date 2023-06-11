import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppStyle {
  static const heading1 = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black
  );

  static TextStyle heading2 = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Get.isDarkMode ? Colors.white : Colors.black
  );
}
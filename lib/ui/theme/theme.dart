import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color bluishClr = Colors.blueAccent;
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = const Color(0xFF424242);


class Themes {
  static final light = ThemeData(
      backgroundColor: Colors.white,
      primarySwatch: Colors.cyan,
      brightness: Brightness.light
  );

  static final dark = ThemeData(
      backgroundColor: darkGreyClr,
      primarySwatch: Colors.blue,
      brightness: Brightness.dark
  );

}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.white:Colors.black
    )
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato (
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}

TextStyle get titleStyle {
  return GoogleFonts.poppins (
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!
      )
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.poppins (
      textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Get.isDarkMode? Colors.white:Colors.black
      )
  );
}
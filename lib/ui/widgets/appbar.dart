import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/theme_services.dart';

AppBar appBar(BuildContext context, var notifyHelper) {
  return AppBar(
    elevation: 0,
    backgroundColor: context.theme.backgroundColor,
    leading: GestureDetector(
      onTap: (){
        ThemeService().switchTheme();
        notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme"
        );

        // notifyHelper.scheduledNotification();
      },
      child: Icon(Get.isDarkMode ? Icons.wb_sunny_outlined:Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white:Colors.black),
    ),
    actions: const [
      CircleAvatar(
        backgroundImage: AssetImage(
            "assets/icons/img.png"
        ),
      ),
      SizedBox(width: 20,),
    ],
  );
}
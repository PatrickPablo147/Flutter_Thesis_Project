import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/navpages/settings_page.dart';
import 'package:project1/navpages/todo_page.dart';
import 'package:project1/navpages/schedule_page.dart';
import 'package:project1/services/notification_services.dart';

import '../services/theme_services.dart';

class NavbarRoots extends StatefulWidget {
  const NavbarRoots({Key? key}) : super(key: key);

  @override
  State<NavbarRoots> createState() => _NavbarRootsState();
}

class _NavbarRootsState extends State<NavbarRoots> {
  int _index = 0;
  final _screens = [
    //MainPage(),
    SchedulePage(),
    TodoPage(),
    Container()
  ];
  var notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: _screens[_index],
      bottomNavigationBar: Container(
        height: 70,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedItemColor: const Color(0xFF7165D6),
          unselectedItemColor: Colors.black26,
          selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),
          currentIndex: _index,
          onTap: (index){
            setState(() {
              _index = index;
            });
          },
          items: const [
            //BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Schedule"),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Todo"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
          ],


        ),
      ),
    );
  }
  _appBar() {
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

          notifyHelper.scheduledNotification();
        },
        child: Icon(Get.isDarkMode ? Icons.wb_sunny_outlined:Icons.nightlight_round,
            size: 20,
            color: Get.isDarkMode ? Colors.white:Colors.black),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage(
              "images/user.png"
          ),
        ),
        SizedBox(width: 20,),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project1/navpages/my_page.dart';
import 'package:project1/navpages/settings_page.dart';
import 'package:project1/navpages/task_list_page.dart';
import 'package:project1/ui/date_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            activeColor: Colors.black,
            inactiveColor: Colors.grey,
            backgroundColor: Colors.white,
            height: 65,
            iconSize: 25,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded)),
              BottomNavigationBarItem(icon: Icon(Icons.assignment_add)),
              BottomNavigationBarItem(icon: Icon(Icons.checklist_rtl_outlined)),
              BottomNavigationBarItem(icon: Icon(Icons.density_medium_rounded)),
            ]),
        tabBuilder: (context, index){
          switch(index){
            case 0: return CupertinoTabView(
              builder: (context) => CupertinoPageScaffold(child: MyPage()),
            );
            case 1: return CupertinoTabView(
              builder: (context) => CupertinoPageScaffold(child: DatePage()),
            );
            case 2: return CupertinoTabView(
              builder: (context) => CupertinoPageScaffold(child: TaskListPage()),
            );
            case 3: return CupertinoTabView(
              builder: (context) => CupertinoPageScaffold(child: SettingsPage()),
            );
          }

          return Container();
        }
    );
  }
}

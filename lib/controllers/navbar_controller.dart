import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/pages/navpages/profile_page.dart';
import 'package:project1/services/notification_services.dart';
import 'package:project1/ui/widgets/appbar.dart';
import '../pages/navpages/schedule_page.dart';
import '../pages/navpages/todo_page.dart';
import '../services/theme_services.dart';

class NavbarRoots extends StatefulWidget {
  const NavbarRoots({Key? key}) : super(key: key);

  @override
  State<NavbarRoots> createState() => _NavbarRootsState();
}

class _NavbarRootsState extends State<NavbarRoots> {
  int _index = 0;
  final _screens = [
    const SchedulePage(),
    const TodoPage(),
    const ProfilePage()
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
      appBar: appBar(context, notifyHelper),
      backgroundColor: Colors.white,
      body: _screens[_index],
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedItemColor: Colors.blueAccent,
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
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Schedule"),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Todo"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

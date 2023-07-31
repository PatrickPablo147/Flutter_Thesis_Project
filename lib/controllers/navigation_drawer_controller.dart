import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project1/pages/navpages/archive_page.dart';
import 'package:project1/pages/navpages/help_center_page.dart';
import 'package:project1/ui/theme/theme.dart';
import '../services/theme_services.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer( {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)
        ),
        child: Drawer(
          width: 270,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildHeader(context),
                  buildMenuItems(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
    child: Center(child: Column(
      children: [
        Text("LOGO HERE!", style: textStyle.copyWith(fontSize: 40, height: 1),),
        Text("meTime!", style: textStyle,)
      ],
    ),)
  );

  Widget buildMenuItems(BuildContext context) => Wrap(
    runSpacing: 16,
    children: [
      ListTile(
        leading: const Icon(LineAwesomeIcons.home,),
        title: Text('Home', style: textStyle,),
        onTap: (){
          Get.back();
        },
      ),
      ListTile(
        leading: const Icon(LineAwesomeIcons.archive,),
        title: Text('Archive', style: textStyle,),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ArchivePage())),
      ),
      ListTile(
        leading: Icon(Get.isDarkMode ? LineAwesomeIcons.sun : LineAwesomeIcons.moon,),
        title: Text('Theme', style: textStyle,),
        onTap: (){
          ThemeService().switchTheme();
        },
      ),
      const Padding(
        padding: EdgeInsets.only(left: 10, right: 30),
        child: Divider(thickness: 1,),
      ),
      ListTile(
        leading: const Icon(LineAwesomeIcons.cog,),
        title: Text('Settings', style: textStyle,),
        onTap: (){},
      ),
      ListTile(
        leading: const Icon(LineAwesomeIcons.info_circle,),
        title: Text('About', style: textStyle,),
        onTap: (){
          Fluttertoast.showToast(
            msg: 'Personalize Time Management App\nVersion: 0.0.1',
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54
          );
        },
      ),
      ListTile(
        leading: const Icon(LineAwesomeIcons.question_circle,),
        title: Text('Help Center', style: textStyle,),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterPage())),
      ),
    ],
  );


}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project1/ui/theme/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  width: 120, height: 120,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/user.png"),
                  ),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("First name", style: subTitleStyle,),
                    Gap(10),
                    Text("Last name", style: subTitleStyle,)
                  ],
                ),
                Text("Email_Address@gmail.com", style: subTitleStyle,),
                const Gap(20),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      side: BorderSide.none,
                      shape: const StadiumBorder()
                    ),
                    child: Text("Edit Profile", style: subTitleStyle.copyWith(color: Colors.white),),
                  ),
                ),
                const Gap(15),
                const Divider(),
                const Gap(15),

                ProfileMenuWidget(title: "My Account", icon: LineAwesomeIcons.user, onPress: (){},),
                const Gap(5),
                ProfileMenuWidget(title: "Notification", icon: LineAwesomeIcons.bell, onPress: (){},),
                const Gap(5),
                ProfileMenuWidget(title: "Settings", icon: LineAwesomeIcons.cog, onPress: (){},),
                const Gap(35),
                ProfileMenuWidget(title: "Help Center", icon: LineAwesomeIcons.question_circle, onPress: (){},),
                const Gap(5),
                ProfileMenuWidget(title: "Logout", icon: LineAwesomeIcons.alternate_sign_out, onPress: (){}, endIcon: false,),
                const Gap(5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        onTap: onPress,
        leading: Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blueAccent.withOpacity(0.1),
          ),
          child: Icon(icon),
        ),
        title: Text(title,),
        trailing: endIcon ? const SizedBox(
          width: 30, height: 30,
          child: Icon(LineAwesomeIcons.angle_right, size: 18, color: Colors.grey,),
        ) : null,
      ),
    );
  }
}

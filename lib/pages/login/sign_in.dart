import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/controllers/navbar_controller.dart';
import 'package:project1/pages/login/sing_up.dart';
import 'package:project1/pages/navpages/home_page.dart';
import 'package:project1/pages/navpages/schedule_page.dart';
import 'package:project1/ui/widgets/sign_in_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: buildAppBar("Log In"),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildThirdPartyLogin(context),
                Center(child: reusableText("Or use your email account to login")),
                Container(
                  margin: EdgeInsets.only(top: 66.h),
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reusableText("Email"),
                      const SizedBox(height: 5),
                      buildTextField("Enter your email", "email", "user"),
                      reusableText("Password"),
                      const SizedBox(height: 5),
                      buildTextField("Enter your password", "password", "lock"),
                    ],
                  ),
                ),
                forgotPassword(),
                buildLoginAndRegButton("Log in", "login",
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()))
                ),
                buildLoginAndRegButton("Sign up", "register",
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUp()))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

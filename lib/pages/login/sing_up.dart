import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/pages/login/sign_in.dart';
import 'package:project1/ui/widgets/sign_in_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: buildAppBar("Sign Up"),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Center(child: reusableText("Fill up the details to create an   account"))),
                Container(
                  margin: EdgeInsets.only(top: 60.h),
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reusableText("First Name"),
                      buildTextField("Enter your first name", "email", "user"),
                      reusableText("Last Name"),
                      buildTextField("Enter your last name", "email", "user"),
                      reusableText("Email"),
                      buildTextField("Enter your email address", "email", "user"),
                      reusableText("Password"),
                      buildTextField("Enter your password", "password", "lock"),
                      reusableText("Confirm Password"),
                      buildTextField("Enter your confirm password", "password", "lock"),
                    ],
                  ),
                ),
                buildLoginAndRegButton("Sign up", "register",
                        () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignIn()))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

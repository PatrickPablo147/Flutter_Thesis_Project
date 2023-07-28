import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/ui/theme/theme.dart';

AppBar buildAppBar(String type) {
  return AppBar(
    backgroundColor: Colors.white24,
    elevation: 0,
    centerTitle: true,
    title: Text(
      type,
      style: subHeadingStyle,
      // style: TextStyle(
      //     color: Colors.black,
      //     fontSize: 16.sp,
      //     fontWeight: FontWeight.normal
      // ),
    ),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(1.0),
      child: Container(
        color: Colors.grey.withOpacity(0.5),
        height: 1.0,
      ),
    ),
  );
}
//We need context for accessing bloc
Widget buildThirdPartyLogin(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 40.h, bottom: 20.h),
    padding: EdgeInsets.only(left: 25.w, right: 25.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _reusableIcon("google"),
        _reusableIcon("phone_login"),
        _reusableIcon("facebook")
      ],
    )
  );
}

Widget buildTextField(String hintText, String textType, String iconName) {
  return Container(
    width: 325.w,
    height: 45.h,
    margin: EdgeInsets.only(bottom: 13.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.w),
      border: Border.all(color: Colors.black26)
    ),
    child: Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 17.w),
          width: 16.w,
          height: 16.w,
          child: Image.asset("assets/icons/${iconName}.png"),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.w),
          alignment: Alignment.center,
          width: 260.w,
          height: 50.h,
          child: TextField(
            keyboardType: TextInputType.multiline,
            autocorrect: false,
            obscureText: textType=="password" ? true : false,
            decoration: InputDecoration(
              hintText: hintText,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintStyle: TextStyle(
                color: Colors.grey.withOpacity(0.5)
              )
            ),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 14.sp
            ),
          ),
        )
      ],
    )
  );
}

Widget buildLoginAndRegButton(String buttonName, String buttonType, void Function()? func) {
  return GestureDetector(
    onTap: func,
    child: Container(
      width: 325.w,
      height: 50.w,
      margin: EdgeInsets.only(left: 25.w, right: 25.w, top: buttonType=="login" ? 40.h : 20.h),
      decoration: BoxDecoration(
        color: buttonType=="login" ? Colors.blueAccent : Colors.white,
        borderRadius: BorderRadius.circular(15.w),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
            color: Colors.grey.withOpacity(1)
          )
        ]
      ),
      child: Center(
        child: Text(
          buttonName,
          style: subTitleStyle.copyWith(color: buttonType=="login" ? Colors.white : Colors.black),
        ),
      ),
    ),
  );
}

Widget reusableText(String text) {
  return Container(
    margin: EdgeInsets.only(bottom: 5.h),
    child: Text(
      text,
      style: textStyle
    ),
  );
}

Widget forgotPassword() {
  return Container(
    margin: EdgeInsets.only(left: 25.w),
    width: 260.w,
    height: 44.h,
    child: GestureDetector(
      onTap: () {},
      child: Text(
        "Forgot Password?",
        style: TextStyle(
          color: Colors.black,
          decoration: TextDecoration.underline,
          fontSize: 12.sp
          )
        ),
      ),
  );
}

Widget _reusableIcon(String iconName) {
  return GestureDetector(
    onTap: () {},
    child: SizedBox(
      width: 40.w,
      height: 40.w,
      child: Image.asset("assets/icons/${iconName}.png"),
    ),
  );
}

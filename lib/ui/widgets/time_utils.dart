import 'package:flutter/material.dart';

Future<String?> getTimeFromUser(BuildContext context, {required bool isStartTime}) async {
  var pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (pickedTime == null) {
    print("Time cancel");
    return null;
  } else {
    String formattedTime = pickedTime.format(context);
    return formattedTime;
  }
}
  
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


Future<DateTime?> getDateFromUser(BuildContext context, TextEditingController dateController) async {
  DateTime? pickerDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2010),
    lastDate: DateTime(2121),
  );

  if (pickerDate != null) {
    dateController.text = DateFormat.yMd().format(pickerDate);
  } else {
    //Get.back();
    print("it's null or something is wrong");
  }

  return pickerDate;
}

Future<TimeOfDay?> showTimePickerDialog(BuildContext context, TimeOfDay initialTime) async {
  return showTimePicker(
    initialEntryMode: TimePickerEntryMode.input,
    context: context,
    initialTime: initialTime,
  );
}

Future<TimeOfDay?> getTimeFromUser(BuildContext context, bool isStartTime, String startTime, String endTime) async {
  TimeOfDay? pickedTime = await showTimePickerDialog(
    context,
    TimeOfDay(
      hour: int.parse(startTime.split(":")[0]),
      minute: int.parse(startTime.split(":")[1].split(" ")[0]),
    ),
  );

  if (pickedTime == null) {
    Get.back();
    //print("Time cancel");
  } else if (isStartTime) {
    return pickedTime;
  } else {
    return pickedTime;
  }

  return null;
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../models/task.dart';
import '../theme/theme.dart';

class TaskWidget extends StatelessWidget {
  final Task? task;
  const TaskWidget(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: const EdgeInsets.only(left: 5, top: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            //color: const Color(0xFFc3d7ee),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                spreadRadius: 2
              )
            ]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100, width: 10, 
              decoration: BoxDecoration(
                color: task!.isCompleted == 1 ? Colors.green : _timeComparison(task!.startTime!) ? Colors.red : Colors.blue,
                //color: _getCatColor(task!.color??0),
                //color: (DateTime.parse(task!.startTime!).isBefore(DateTime.now())) ? Colors.red : Colors.blue,
                borderRadius: BorderRadius.circular(20)
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: 45, width: 45,
                child: Image(image: AssetImage("assets/images/${_getTitleIcon(task!.color??0)}.png"),)
              ),
              //child: Container(height: 60, width: 60, color: Colors.white,),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              task?.title??"",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal
                                ),
                              )
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_filled,
                                  size: 17,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  "${task!.startTime}", // - ${task!.endTime}",
                                  style: const TextStyle(
                                      color: Colors.black
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const Gap(5),
                        Text(task?.note??"", style: const TextStyle(color: Colors.black87),)
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: Colors.black12,
                      thickness: 2,
                      height: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(_getRecurrenceIcon(task!.repeat!), color: Colors.blueAccent,),
                        const Gap(5),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('M:d:y').format(DateFormat.yMd().parse(task!.date!)),
                                style: textStyle
                              ),
                              const Text('--'),
                              Text(
                                task!.repeat == 'None' ? "End time" :
                                _getRecurrence(task!.repeat!),
                                style: textStyle,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getRecurrenceIcon(String iconName) {
    switch(iconName) {
      case 'None' : return LineAwesomeIcons.calendar_minus;
      case 'Daily' : return LineAwesomeIcons.alternate_calendar;
      case 'Weekly' : return LineAwesomeIcons.calendar_with_week_focus;
      case 'Monthly' : return LineAwesomeIcons.calendar_plus;
    }
  }

  _getRecurrence(String recur) {
    switch(recur) {
      case 'None' : return DateFormat('M:d:y').format(DateFormat.yMd().parse(task!.date!));
      case 'Daily' : return DateFormat('M:d:y').format(DateFormat.yMd().parse(task!.date!).add(Duration(days: task!.remind!)));
      case 'Weekly' : return DateFormat('M:d:y').format(DateFormat.yMd().parse(task!.date!).add(Duration(days: task!.remind! * 7)));
      case 'Monthly' : return DateFormat('M:d:y').format(DateFormat.yMd().parse(task!.date!).add(Duration(days: task!.remind! * 30)));
    }
  }

  _timeComparison(String task) {
    DateTime now = DateTime.now();
    DateTime startTime = DateFormat .jm().parse(task);

    // Create a DateFormat instance for formatting and parsing in the 'hh:mm a' format
    DateFormat dateFormat = DateFormat.jm();
    // Format the current time
    String formattedNow = dateFormat.format(now);
    // Parse the formattedNow string back to a DateTime object
    DateTime parsedNow = dateFormat.parse(formattedNow);
    //compare two DateTime objects
    bool isBefore = (startTime.isBefore(parsedNow));

    return isBefore;
  }

  _getTitleIcon(int no) {
    switch (no) {
      case 0: return 'general';
      case 1: return 'celebrate';
      case 2: return 'exercise';
      case 3: return 'study';
      case 4: return 'meeting';
    }
  }
}
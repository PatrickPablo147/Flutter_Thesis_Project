import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project1/ui/theme/theme.dart';
import '../../models/task.dart';

class TaskInfo extends StatelessWidget {
  TaskInfo(this.task, {super.key}) ;

  final Task? task;
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      color: Colors.blue.shade100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 15, top: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: 30, width: 30,
                  child: Image(image: AssetImage("assets/images/${_getTitleIcon(task!.title!)}.png"),)
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task!.title??'', style: textStyle.copyWith(fontSize: 30),),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task!.note??'', style: textStyle,),
                            const Gap(20),
                            Text('Schedule :', style: textStyle.copyWith(color: Colors.grey, fontSize: 10),),
                            //Gap(2),
                            Row(
                              children: [
                                Text('Time : ', style: textStyle,),
                                const Icon(LineAwesomeIcons.clock, size: 18, color: Colors.blueAccent,),
                                const Gap(5),
                                Text(task!.startTime??'', style: textStyle,),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Date : ', style: textStyle,),
                                const Icon(LineAwesomeIcons.calendar_with_week_focus, size: 18, color: Colors.blueAccent,),
                                const Gap(5),
                                Text(DateFormat('MMMM d, y').format(DateFormat.yMd().parse(task!.date!)), style: textStyle,),
                              ],
                            ),
                            Row(
                              children: [
                                Text('End   : ', style: textStyle,),
                                const Icon(LineAwesomeIcons.calendar_with_week_focus, size: 18, color: Colors.blueAccent,),
                                const Gap(5),
                                Text(
                                  task!.repeat == 'None' ? "End time" :
                                  _getRecurrence(task!.repeat!),
                                  style: textStyle,)
                              ],
                            ),

                            const Gap(20),
                            Text('Status :', style: textStyle.copyWith(color: Colors.grey, fontSize: 10),),
                            Row(
                              children: [
                                Text('Remind : ', style: textStyle,),
                                Text(task!.repeat??'', style: textStyle,)
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: task!.isCompleted == 1 ? Colors.green :  Colors.blue,
                                    shape: BoxShape.circle
                                  ),
                                ),
                                const Gap(5),
                                Text(
                                  task!.isCompleted == 1 ? "Complete" : "Pending",
                                  style: textStyle,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Icon(LineAwesomeIcons.vertical_ellipsis, size: 30,)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              color: Colors.grey,
              height: 20,
            ),
          )
        ],
      ),
    );
  }

  _getRecurrence(String recur) {
    switch(recur) {
      case 'None' : return DateFormat('MMM d, y').format(DateFormat.yMd().parse(task!.date!));
      case 'Daily' : return DateFormat('MMM d, y').format(DateFormat.yMd().parse(task!.date!).add(Duration(days: task!.remind!)));
      case 'Weekly' : return DateFormat('MMM d, y').format(DateFormat.yMd().parse(task!.date!).add(Duration(days: task!.remind! * 7)));
      case 'Monthly' :
        DateTime startDate = DateFormat.yMd().parse(task!.date!);
        // Calculate the next month's date based on the recurrence
        DateTime endDate = DateTime(startDate.year, startDate.month + task!.remind!, startDate.day);

        // Check if the day of the endDate is greater than the last day of the month
        // If it is, set the end date to the last day of the month
        int lastDayOfMonth = DateTime(endDate.year, endDate.month + 1, 0).day;
        if (endDate.day > lastDayOfMonth) {
          endDate = DateTime(endDate.year, endDate.month, lastDayOfMonth);
        }
        return DateFormat('MMM d, y').format(endDate);
    }
  }

  _getTitleIcon(String title) {
    switch (title) {
      case 'General': return 'general';
      case 'Celebration': return 'celebrate';
      case 'Exercise': return 'exercise';
      case 'Study': return 'study';
      case 'Meeting': return 'meeting';
    }
  }

}
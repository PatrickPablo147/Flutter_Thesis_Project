import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:project1/controllers/task_controller.dart';
import 'package:project1/models/task.dart';
import 'package:project1/ui/theme/theme.dart';
import 'package:project1/ui/widgets/reschedule_widget.dart';
import 'package:project1/ui/widgets/task_info.dart';
import 'package:project1/ui/widgets/task_widget.dart';


Widget buildTaskTileWidget(BuildContext context, Task task, int index, TaskController taskController) {
  return AnimationConfiguration.staggeredList(
    position: index,
    child: SlideAnimation(
      child: FadeInAnimation(
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _showBottomSheet(context, task, taskController);
              },
              child: TaskWidget(task)
            )
          ],
        ),
      ),
    ),
  );
}

Widget buildTaskInfoWidget(BuildContext context, Task task, int index, TaskController taskController) {
  return AnimationConfiguration.staggeredList(
    position: index,
    child: SlideAnimation(
      child: FadeInAnimation(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                  onTap: () {
                    _showBottomSheet(context, task, taskController);
                  },
                  child: TaskInfo(task)
              ),
            )
          ],
        ),
      ),
    ),
  );
}

_showBottomSheet(BuildContext context, Task task, TaskController taskController) {
  Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1?
        MediaQuery.of(context).size.height*0.24:
        MediaQuery.of(context).size.height*0.32,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40)
          ),
          color: Get.isDarkMode?darkGreyClr:Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300]
              ),
            ),
            const Spacer(),
            task.isCompleted==1
                ? Container() : _bottomSheetButton(
              lable: "Task Completed",
              onTap: (){
                //taskController.delete(task);
                taskController.markTaskCompleted(task.id!);
                Get.back();
              },
              clr: primaryClr,
              context: context,
            ),
            _bottomSheetButton(
              lable: "Reschedule Task",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RescheduleEvent(task: task,))
                );
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            const SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
              lable: "Close",
              onTap: (){
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose: true,
              context: context,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      )
  );
}

_bottomSheetButton({required String lable,
  required Function()? onTap,
  required Color clr,
  bool isClose = false,
  required BuildContext context
}){
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 55,
      width: MediaQuery.of(context).size.width*0.9,
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr
        ),
        borderRadius: BorderRadius.circular(12),
        color: isClose==true?Colors.transparent:clr,
      ),
      child: Center(
        child: Text(
          lable,
          style: isClose?subTitleStyle:subTitleStyle.copyWith(color: Colors.white),
        ),
      ),
    ),
  );
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

Future openDialog(BuildContext context, Task task, TaskController taskController) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Are your task Completed now?'),
      // content: TextField(
      //   decoration: InputDecoration(hintText: 'Enter your name'),
      // ),
      actions: [
        TextButton(
          onPressed: () {
            taskController.markTaskCompleted(task.id!);
            Get.back();
            //Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Yes')
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text('No')
        )
      ],
    )
);
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project1/ui/theme/theme.dart';
import 'package:project1/ui/widgets/time_container_widget.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import 'date_time_utils.dart';

class TaskInfo extends StatelessWidget {
  TaskInfo(this.task, {super.key});

  final Task? task;
  final _taskController = Get.put(TaskController());
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime(2010, 1, 1);
  final String _startTime= DateFormat("hh:mm a").format(DateTime.now()).toString();
  final String _endTime= DateFormat("hh:mm a").format(DateTime.now()).toString() ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 15, top: 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                spreadRadius: 2
              )
            ]
        ),
        child: Column(
          children: [
            const Gap(10),
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
                        style: const TextStyle(
                          fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        task?.date??"",
                        style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400
                        ),
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
                thickness: 1,
                height: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${task!.startTime} - ${task!.endTime}",
                        style: const TextStyle(
                            color: Colors.black54
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: task!.isCompleted == 1 ? Colors.green : Colors.red,
                            //color: Colors.green,
                            shape: BoxShape.circle
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        task!.isCompleted == 1 ? "COMPLETED" : "PENDING",
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Delete button
                InkWell(
                  onTap: () {
                    _taskController.delete(task!);
                  },
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF4F6FA),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Center(
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ),
                //Change date button
                InkWell(
                  onTap: () {
                    _showBottomSheet(context, task!, _taskController);
                  },
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade800,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Center(
                      child: Text(
                        "Reschedule",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Gap(10),
          ],
        ),
      ),
    );

  }

  _getDateFromUser(BuildContext context) async {
    DateTime? selectedDate = await getDateFromUser(context, _dateController);

    if (selectedDate != null) {
      _selectedDate = selectedDate;
      _dateController.text = DateFormat.yMd().format(_selectedDate);
      // Handle the selected date as needed
    }
    // Handle the case when selectedDate is null if needed.
  }

  _validateDateUpdate() {
    DateTime dateValue = DateFormat.yMd().parse(task!.date!);
    if(_selectedDate.isAfter(dateValue.subtract(const Duration(days: 1)))){
      _taskController.changeDateTime(task!.id!, DateFormat.yMd().format(_selectedDate), _startTime, _endTime);
    }
    else {
      Get.snackbar("Required", "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
  }

  _showBottomSheet(BuildContext context, Task task, TaskController taskController) {
    Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(top: 4),
          height: MediaQuery.of(context).size.height*0.38,
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
                width: 110,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300]
                ),
              ),

              const Gap(25),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date', style: subTitleStyle),
                    const Gap(6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                            color: Colors.black
                        ),
                        decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey,),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: task.date,
                            hintStyle: TextStyle(
                                color: Colors.grey.shade500
                            )
                        ),
                        controller: _dateController,
                        onTap: () {
                          _getDateFromUser(context);
                        },
                      ),
                    ),

                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TimeContainerWidget(
                          titleText: 'Start Time',
                          valueText: task.startTime.toString(),
                          onTap: () {
                            getTimeFromUser(context, true, _startTime, _endTime);
                          },
                        ),
                        const Gap(12),
                        TimeContainerWidget(
                          titleText: 'End Time',
                          valueText: task.endTime.toString(),
                          onTap: () {
                            getTimeFromUser(context, false , _startTime, _endTime,);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),
              //Save and Cancel button
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _bottomSheetButton(
                    lable: "Cancel",
                    onTap: (){
                      Get.back();
                    },
                    clr: Colors.red[300]!,
                    isClose: true,
                    context: context,
                  ),
                  const Gap(10),
                  _bottomSheetButton(
                    lable: "Save",
                    onTap: (){
                      _validateDateUpdate();
                      Get.back();
                    },
                    clr: primaryClr,
                    context: context,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )
    );
  }

  _bottomSheetButton({
    required String lable,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context
  }){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        height: 55,
        width: MediaQuery.of(context).size.width/2.2,
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
}
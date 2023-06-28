/*This Class Manage the DatePage*/
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project1/controllers/task_controller.dart';
import 'package:project1/services/notification_services.dart';
import 'package:project1/models/add_task_model.dart';
import 'package:project1/ui/theme/theme.dart';
import '../../models/task.dart';
import '../../ui/widgets/task_widget.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  /*
  * Variables for Time, Task Controller and Notification
  * */
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  //late DateTime targetMonth = DateTime(_selectedDate.year, _selectedDate.month * 1, _selectedDate.day * 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: appBar(context, notifyHelper),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 20,),
          _showTasks(),
        ],
      ),
    );
  }

  bool _isRecurringMonthlyTask(Task task, DateTime taskDate) {
    DateTime currentDate = DateTime(_selectedDate.year, _selectedDate.month, taskDate.day);

    if (currentDate.isBefore(_selectedDate)) {
      currentDate = currentDate.add(const Duration(days: 30));
    }
    return currentDate.isAtSameMomentAs(_selectedDate);
  }

  bool _isRecurringWeeklyTask(Task task, DateTime taskDate) {
    DateTime currentDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    if (currentDate.isAfter(taskDate)) {
      int differenceInDays = currentDate.difference(taskDate).inDays;
      int weeksToAdd = (differenceInDays / 7).ceil();
      currentDate = taskDate.add(Duration(days: weeksToAdd * 7));
    }

    return currentDate.isAtSameMomentAs(_selectedDate);
  }

  //Get Date From User ->> Pop up Date Picker
  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2121)
    );
    if (pickerDate!=null){
      setState(() {
        _selectedDate = pickerDate;
      });
    }
    else {
      print("it's null or somethings is wrong");
    }
  }

  /*Custom Functions*/
  //Show the created Task
  _showTasks(){
    _taskController.getTasks();
    return Expanded(
      child: Obx((){
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index){
            Task task = _taskController.taskList[index];
            //print(task.toJson());
            DateTime dateFormatted = DateFormat.yMd().parse(task.date!);
            //Condition to show the Task
            if (task.isCompleted == 0) {
              switch (task.repeat){
                case 'Daily': {
                  if(dateFormatted.isBefore(_selectedDate)){
                    return buildTaskWidget(context, task, index, _taskController);
                  }
                } break;
                case 'Weekly': {
                  if (_isRecurringWeeklyTask(task, dateFormatted)) {
                    return buildTaskWidget(context, task, index, _taskController);
                  }
                } break;
                case 'Monthly': {
                  if (_isRecurringMonthlyTask(task, dateFormatted)) {
                    return buildTaskWidget(context, task, index, _taskController);
                  }
                }break;
                case 'None': {
                  if(task.date == DateFormat.yMd().format(_selectedDate)){
                    return buildTaskWidget(context, task, index, _taskController);
                  }
                }break;
                default: {
                  return Container();
                }
              // if(task.repeat == 'Daily') {
              //   if(dateFormatted.isBefore(_selectedDate)){
              //     return buildTaskWidget(context, task, index, _taskController);
              //   }
              // }
              // else if (task.repeat == 'Weekly') {
              //   if (_isRecurringWeeklyTask(task, dateFormatted)) {
              //     return buildTaskWidget(context, task, index, _taskController);
              //   }
              // }
              // else if (task.repeat == 'Monthly') {
              //   if (_isRecurringMonthlyTask(task, dateFormatted)) {
              //     return buildTaskWidget(context, task, index, _taskController);
              //   }
              // }
              // if(task.date == DateFormat.yMd().format(_selectedDate)){
              //   return buildTaskWidget(context, task, index, _taskController);
              // }
              // else {
              //   return Container();
              //{
              }
            }
            if(task.date == DateFormat.yMd().format(_selectedDate)){
              return buildTaskWidget(context, task, index, _taskController);
            }
            else {
              return Container();
            }
          }
        );
      }),
    );
  }
  //Date Text and Add Task Button
  _addTaskBar(){
    return  Container(
      //padding: EdgeInsets.only(top: 60, left: 20),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(DateFormat.yMMMMd().format(_selectedDate),
                  style: subHeadingStyle
              ),
              const Gap(12),
              GestureDetector(
                onTap: () {
                  _getDateFromUser();
                },
                child: const Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                  color: Colors.grey,
                ),
              )
              // Text("Today",
              //   style: headingStyle,
              // )
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25)
            ),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTaskModel())
              );
              _taskController.getTasks();
            },
            child: const Text('+ Add Task'),
          ),
        ],
      ),
    );
  }
  //Horizontal Date Picker
  _addDateBar() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20, left: 20),
        child: DatePicker(
        _selectedDate.isBefore(DateTime.now())
            ?_selectedDate
            : DateTime.now(),
        height: 120,
        width: 80,
        initialSelectedDate: _selectedDate,
        selectionColor: Colors.blue.shade800,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
            )
        ),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
            )
        ),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        onDateChange: (date){
          setState(() {
            _selectedDate = date;
          });
        },

      ),
    );
  }
}

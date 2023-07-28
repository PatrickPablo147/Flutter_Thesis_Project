/*This Class Manage the DatePage*/
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project1/controllers/task_controller.dart';
import 'package:project1/models/add_task_model.dart';
import 'package:project1/ui/theme/theme.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../ui/widgets/build_task_widget.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;


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

  //Check to recur weekly or monthly
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

  _getNotify(date, task) {
    var myTime = DateFormat("HH:mm").format(date);
    return notifyHelper.scheduledNotification(
        int.parse(myTime.toString().split(":")[0]),
        int.parse(myTime.toString().split(":")[1]),
        task
    );
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
              //Condition to show the created Task
              if (dateFormatted.isBefore(_selectedDate)) {
                switch (task.repeat){
                  case 'Daily': {
                    DateTime date = DateFormat.jm().parse(task.startTime.toString());
                    _getNotify(date, task);
                    return buildTaskTileWidget(context, task, index, _taskController);
                  } break;
                  case 'Weekly': {
                    if (_isRecurringWeeklyTask(task, dateFormatted)) {
                      DateTime date = DateFormat("hh:mm a").parse(task.startTime.toString());
                      _getNotify(date, task);
                      return buildTaskTileWidget(context, task, index, _taskController);
                    }
                  } break;
                  case 'Monthly': {
                    if (_isRecurringMonthlyTask(task, dateFormatted)) {
                      DateTime date = DateFormat("hh:mm a").parse(task.startTime.toString());
                      _getNotify(date, task);
                      return buildTaskTileWidget(context, task, index, _taskController);
                    }
                  }break;
                  case 'None': {
                    if(task.date == DateFormat.yMd().format(_selectedDate) && task.isCompleted == 0){
                      DateTime date = DateFormat.jm().parse(task.startTime.toString());
                      _getNotify(date, task);
                      return buildTaskTileWidget(context, task, index, _taskController);
                    }
                  }break;
                  default: {
                    return Container();
                  }
                }
              }
              if(task.date == DateFormat.yMd().format(_selectedDate) && task.isCompleted == 0){
                DateTime date = DateFormat.jm().parse(task.startTime.toString());
                _getNotify(date, task);
                return buildTaskTileWidget(context, task, index, _taskController);
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(DateFormat.yMMMMd().format(_selectedDate),
                  style: subTitleStyle
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
            child: Text('+ Add Task', style: textStyle.copyWith(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  //Horizontal Date Picker
  _addDateBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 100, bottom: 15),
      child: Transform.scale(
        scale: 1.5,
        //Custom Calendar Widget
        child: CalendarTimeline(
          initialDate: _selectedDate,  //DateTime(2020, 4, 20),
          firstDate: DateTime(2010, 1, 1),
          lastDate: DateTime(2040, 11, 20),
          onDateSelected: (date) => setState(() {
            _selectedDate = date;
          }),
          leftMargin: 0,
          monthColor: Colors.black45,
          dayColor: Colors.blueAccent,
          activeDayColor: Colors.white,
          activeBackgroundDayColor: Colors.blue.shade800,
          dotsColor: Colors.transparent,//const Color(0xFFFFFFFF).withOpacity(0.8),
          locale: 'en_ISO',
          selectableDayPredicate: null,
        ),
      ),
    );
  }
}

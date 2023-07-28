/*This Class Manage the DatePage*/
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project1/controllers/task_controller.dart';
import 'package:project1/models/add_task_model.dart';
import 'package:project1/ui/theme/theme.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../ui/widgets/build_task_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  bool _checker = true;


  final List<NeatCleanCalendarEvent> _eventList = [
    NeatCleanCalendarEvent('MultiDay Event A',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 10, 0),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 2, 12, 0),
        color: Colors.orange,
        isMultiDay: true),
    NeatCleanCalendarEvent('Allday Event B',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day - 2, 14, 30),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 2, 17, 0),
        color: Colors.pink,
        isAllDay: true),
    NeatCleanCalendarEvent('Normal Event D',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 14, 30),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 17, 0),
        color: Colors.indigo),
  ];

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: const Icon(LineAwesomeIcons.bars, size: 30,),
          title: ListTile(
            leading: Text('Hello', style: textStyle.copyWith(fontSize: 25, fontWeight: FontWeight.normal),),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddTaskModel())
                    );
                  },
                  child: Center(
                    child: Text('+ Event', style: textStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: _calendarBar()
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

  _getNotify(date, task) {
    var myTime = DateFormat("HH:mm").format(date);
    return notifyHelper.scheduledNotification(
        int.parse(myTime.toString().split(":")[0]),
        int.parse(myTime.toString().split(":")[1]),
        task
    );
  }

  /*Custom Functions*/

  _calendarBar() {
    _taskController.getTasks();
    return Calendar(
      startOnMonday: false,
      weekDays: const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      eventsList: _eventList,
      eventListBuilder: (context, day) {
        return Expanded(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.grey.withOpacity(0.2),
              height: _checker ? 375 : 575,
              //constraints: BoxConstraints(maxHeight: _checker ? 355 : 555),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: _showTasks(),
              ),
            ),
          ),
        );
      },
      onExpandStateChanged: (check) {
        _checker = check;
      },
      isExpandable: true,
      isExpanded: true,
      eventDoneColor: Colors.green,
      selectedColor: Colors.blueAccent,
      selectedTodayColor: Colors.blueAccent,
      todayColor: Colors.blue,
      eventColor: null,
      onDateSelected: (value){
        setState(() {
          _selectedDate = value;
        });
      },
      locale: 'en_ISO',
      hideTodayIcon: true,
      allDayEventText: 'All day',
      multiDayEndText: 'End',
      expandableDateFormat: 'MMMM dd, yyyy',
      datePickerType: DatePickerType.date,
      displayMonthTextStyle: GoogleFonts.poppins(
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20
        )
      ),
      bottomBarTextStyle: GoogleFonts.poppins(
        color: Colors.grey,
        fontSize: 14
      ),
      dayOfWeekStyle: GoogleFonts.poppins(
        textStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.normal, fontSize: 11
        ),
      ),
    );
  }

  //Show the created Task
  _showTasks(){
    return Obx((){
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          shrinkWrap: true,
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
                }
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
                  if(task.date == DateFormat.yMd().format(_selectedDate)){
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
            if(task.date == DateFormat.yMd().format(_selectedDate)){
              DateTime date = DateFormat.jm().parse(task.startTime.toString());
              _getNotify(date, task);
              return buildTaskTileWidget(context, task, index, _taskController);
            }
            else {
              return Container();
            }
          }
      );
    });
  }
}

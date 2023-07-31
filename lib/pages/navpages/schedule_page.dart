/*This Class Manage the DatePage*/
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project1/controllers/navigation_drawer_controller.dart';
import 'package:project1/controllers/task_controller.dart';
import 'package:project1/models/add_task_model.dart';
import 'package:project1/ui/theme/theme.dart';
import '../../database/db_helper.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../ui/widgets/build_task_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  List<NeatCleanCalendarEvent> _eventList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadEventsFromDatabase();
    // Load other necessary data or perform additional tasks here
  }
  Future<void> _loadEventsFromDatabase() async {
    // Initialize the database before querying
    await DBHelper.initDb();

    // Fetch data from the database
    List<Map<String, dynamic>> tasksData = await DBHelper.query();

    // Convert the fetched data to NeatCleanCalendarEvent objects and add them to the list
    List<NeatCleanCalendarEvent> events = tasksData.map((taskData) {
      Task task = Task.fromJson(taskData);
      final dateFormat = DateFormat("M/d/yyyy"); // Use the appropriate date format
      return NeatCleanCalendarEvent(
        task.title ?? '', // Ensure to handle null values for title
        startTime: dateFormat.parse(task.date ?? ''),
        endTime: _getRecurEvent(task.reactive.toString(), task),
        color: _getCatColor(task.color!.toInt()),
      );
    }).toList();
    // Update the state with the new list of events
    setState(() {
      _eventList = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const NavDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(LineAwesomeIcons.bars, size: 30),
            onPressed: (){
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: ListTile(
            title: Text('', style: textStyle.copyWith(fontSize: 25, fontWeight: FontWeight.normal),),
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

  // List<Task> _filterTasks() {
  //   return _taskController.taskList.where((task) {
  //     DateTime startTime = DateFormat.yMd().parse(task.date!);
  //     DateTime endTime = _getRecurrence(task.repeat.toString(), task);
  //
  //     // Check if the selected date is within the date range defined by the start and end dates.
  //     DateTime startOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
  //     DateTime endOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 23, 59, 59);
  //     bool isWithinRange = (startOfDay.isBefore(endTime) && endOfDay.isAfter(startTime));
  //
  //     // Check if the task's start date is the same as the selected date.
  //     bool isSameStartDate = DateFormat.yMd().format(startTime) == DateFormat.yMd().format(_selectedDate);
  //
  //     // Check if the task's end date is the same as the selected date.
  //     bool isSameEndDate = DateFormat.yMd().format(endTime) == DateFormat.yMd().format(_selectedDate);
  //
  //     // Check if the task is either within the date range or has its start or end date as the selected date.
  //     bool isWithinDateRange = isWithinRange || isSameStartDate || isSameEndDate;
  //
  //     switch (task.repeat) {
  //       case 'Daily':
  //         return isWithinDateRange;
  //       case 'Weekly':
  //         return (_isRecurringWeeklyTask(task, startTime) && isWithinDateRange);
  //       case 'Monthly':
  //         return (_isRecurringMonthlyTask(task, startTime) && isWithinDateRange);
  //       case 'None':
  //         return isWithinDateRange;
  //       default:
  //         return false;
  //     }
  //   }).toList();
  // }

  List<Task> _filterTasks() {
    return _taskController.taskList.where((task) {
      DateTime startTime = DateFormat.yMd().parse(task.date!);
      DateTime endTime = _getRecurrence(task.repeat.toString(), task);

      // Check if the selected date is within the date range defined by the start and end dates.
      DateTime startOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      DateTime endOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 23, 59, 59);
      bool isWithinRange = (startOfDay.isBefore(endTime) && endOfDay.isAfter(startTime));

      // Check if the task's start date is the same as the selected date.
      bool isSameStartDate = DateFormat.yMd().format(startTime) == DateFormat.yMd().format(_selectedDate);

      // Check if the task's end date is the same as the selected date.
      bool isSameEndDate = DateFormat.yMd().format(endTime) == DateFormat.yMd().format(_selectedDate);

      // Check if the task is either within the date range or has its start or end date as the selected date.
      bool isWithinDateRange = isWithinRange || isSameStartDate || isSameEndDate;

      switch (task.repeat) {
        case 'Daily':
          return isWithinDateRange;
        case 'Weekly':
        // Include 'Weekly' tasks that are within the date range and occur on the selected weekday.
          return (_isRecurWeeklyTask(task, _selectedDate) && isWithinDateRange);
        case 'Monthly':
        // Include 'Monthly' tasks that are within the date range and occur on the selected day of the month.
          return (_isRecurMonthlyTask(task, _selectedDate) && isWithinDateRange);
        case 'None':
          return isWithinDateRange;
        default:
          return false;
      }
    }).toList();
  }

  bool _isRecurWeeklyTask(Task task, DateTime selectedDate) {
    DateTime startTime = DateFormat.yMd().parse(task.date!);
    int weekday = startTime.weekday;
    return selectedDate.weekday == weekday;
  }

  bool _isRecurMonthlyTask(Task task, DateTime selectedDate) {
    DateTime startTime = DateFormat.yMd().parse(task.date!);
    int dayOfMonth = startTime.day;
    return selectedDate.day == dayOfMonth;
  }

  int _compareTasksByStartTime(Task a, Task b) {
    int completedA = a.isCompleted ?? 0;
    int completedB = b.isCompleted ?? 0;
    // Sort by completion status first (0 for not completed, 1 for completed)
    int completedComparison = completedA.compareTo(completedB);

    // If the completion status is different, return the comparison result.
    if (completedComparison != 0) {
      return completedComparison;
    }

    // If the completion status is the same, sort by start time.
    DateTime startTimeA = DateFormat.jm().parse(a.startTime.toString());
    DateTime startTimeB = DateFormat.jm().parse(b.startTime.toString());
    return startTimeA.compareTo(startTimeB);
  }

  _showTasks() {
    return Obx(() {
      List<Task> filteredTasks = _filterTasks();
      filteredTasks.sort(_compareTasksByStartTime);
      return ListView.builder(
        itemCount: filteredTasks.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          Task task = filteredTasks[index];
          DateTime date = DateFormat.jm().parse(task.startTime.toString());
          _getNotify(date, task);
          return buildTaskTileWidget(context, task, index, _taskController);
        },
      );
    });
  }

  _getNotify(date, task) {
    var myTime = DateFormat("HH:mm").format(date);
    return notifyHelper.scheduledNotification(
        int.parse(myTime.toString().split(":")[0]),
        int.parse(myTime.toString().split(":")[1]),
        task
    );
  }

  _calendarBar() {
    _taskController.getTasks();
    return Calendar(
      startOnMonday: false,
      weekDays: const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      eventsList: _eventList,
      eventListBuilder: (context, day) {
        _taskController.getTasks();
        return Expanded(
          child: _showTasks(),
        );
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
              fontSize: 20
          )
      ),
      bottomBarTextStyle: GoogleFonts.poppins(
          color: Colors.grey,
          fontSize: 14
      ),
      dayOfWeekStyle: GoogleFonts.poppins(
        textStyle: const TextStyle(
            fontWeight: FontWeight.normal, fontSize: 11
        ),
      ),
    );
  }


  _getRecurrence(String recur, Task task) {
    switch(recur) {
      case 'None' : return DateFormat.yMd().parse(task.date!);
      case 'Daily' : return DateFormat.yMd().parse(task.date!).add(Duration(days: task.remind!));
      case 'Weekly' : return DateFormat.yMd().parse(task.date!).add(Duration(days: 7 * task.remind!));
      case 'Monthly' :
        DateTime startDate = DateFormat.yMd().parse(task.date!);

        // Calculate the next month's date based on the recurrence
        DateTime endDate = DateTime(startDate.year, startDate.month + task.remind!, startDate.day);

        // If the day of the startDate is greater than the last day of the month,
        // adjust the end date to the last day of the month
        int lastDayOfMonth = DateTime(endDate.year, endDate.month + 1, 0).day;
        if (endDate.day > lastDayOfMonth) {
          endDate = DateTime(endDate.year, endDate.month, lastDayOfMonth);
        }
        return endDate;
    }
  }
  DateTime _getRecurEvent(String recur, Task task) {
    DateTime startDate = DateFormat.yMd().parse(task.date!);

    switch (recur) {
      case 'None':
        return startDate;
      case 'Daily':
        return startDate.add(Duration(days: task.remind!));
      case 'Weekly':
        return startDate.add(Duration(days: 7 * task.remind!));
      case 'Monthly':
        DateTime endDate = DateTime(startDate.year, startDate.month + task.remind!, startDate.day);

        // If the day of the startDate is greater than the last day of the month,
        // adjust the end date to the last day of the month
        int lastDayOfMonth = DateTime(endDate.year, endDate.month + 1, 0).day;
        if (endDate.day > lastDayOfMonth) {
          endDate = DateTime(endDate.year, endDate.month, lastDayOfMonth);
        }
        return endDate;
      default:
        return startDate; // Default case, handle 'None' or any other unknown recurrence pattern
    }
  }

  _getCatColor(int no) {
    switch(no) {
      case 0: return Colors.yellow.shade800;
      case 1: return Colors.pinkAccent;
      case 2: return Colors.blue.shade400;
      case 3: return Colors.green.shade700;
      case 4: return Colors.black54;
    }
  }
}
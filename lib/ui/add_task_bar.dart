/*This class Manage the Adding of Task */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project1/controllers/task_controller.dart';
import 'package:project1/ui/date_page.dart';
import 'package:project1/ui/theme.dart';
import 'package:project1/ui/widgets/button.dart';
import 'package:project1/ui/widgets/input_field.dart';

import '../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  /*
  * Variables use in TaskPage Data input
  * -TaskController Data that calls TaskController class
  * -TextEditingController that input String input
  * -selectedDate variable that save day and time input
  * -endTime & startTime safe time in formatted String
  * -selectedRemind & remindList that controls Alarm Iteration
  * -List of repeatList that manage the TaskWidget to show depending input #
  * -Color that change Title for Tiles
  * */
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime= "12:59 PM";
  String _startTime= DateFormat("hh:mm:a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList=[5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList=[
    "None",
    "Daily",
    "Weekly",
    "Monthly"
  ];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              //InputField controls
              MyInputField(title: "Title", hint: "Enter your title", controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter your note", controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },

                ),),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                        title: "Start Alarm",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: MyInputField(
                      title: "End Alarm"
                          "",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(title: "Remind", hint: "$_selectedRemind minute early",
                widget: DropdownButton(
                  icon:Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child:Text(value.toString())
                    );
                  }
                  ).toList(),
                ),
              ),
              MyInputField(title: "Repeat", hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon:Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items: repeatList.map<DropdownMenuItem<String>>((String? value){
                    return DropdownMenuItem<String>(
                        value: value,
                        child:Text(value!, style:TextStyle(color: Colors.grey))
                    );
                  }
                  ).toList(),
                ),
              ),
              const SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallet(),
                  MyButton(label: "Create Task", onTap: ()=>_validateDate())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //Custom Function
  //Check if Text is not Empty before saving the data into DATABASE
  _validateDate(){
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return DatePage();
      }));
    }
    else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: Icon(Icons.warning_amber_rounded, color: Colors.red),

      );
    }
  }
  // Control that save Data from variable into Database
  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
          note: _noteController.text,
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,
        )
    );
    print("My id is " + "$value");
  }
  //Function that handles Color button
  _colorPallet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Category",
          style: titleStyle,
        ),
        SizedBox(height: 8.0,),
        Wrap(
          children: List<Widget>.generate(3,
                  (int index) {
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedColor = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr,
                      child: _selectedColor==index?Icon(Icons.done,
                        color: Colors.white,
                        size: 16,):Container(),
                    ),
                  ),
                );
              }
          ),
        )

      ],
    );
  }
  //Function that calls the Profile and Return
  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios,
            size: 20,
            color: Get.isDarkMode ? Colors.white:Colors.black),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage(
              "images/user.png"
          ),
        ),
        SizedBox(width: 20,),
      ],
    );
  }
  //Controls the DatePicker
  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121)
    );
    if (_pickerDate!=null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
    else {
      print("it's null or somethings is wrong");
    }
  }
  //Function that get Time in formatted
  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    print(_formatedTime);
    if (pickedTime==null){
      print("Time cancel");
    }
    else if (isStartTime==true) {
      setState(() {
        _startTime = _formatedTime;
      });
    }
    else if (isStartTime==false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }
  //Function that show the Time in a Formatted way and Convert from int to String
  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        )
    );
  }

}

/*This class Manage the Adding of Task */
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project1/controllers/navbar_controller.dart';
import 'package:project1/controllers/task_controller.dart';
import 'package:project1/ui/theme/theme.dart';
import 'package:project1/ui/widgets/time_container_widget.dart';
import 'task.dart';

class AddTaskModel extends StatefulWidget {
  const AddTaskModel({Key? key}) : super(key: key);

  @override
  State<AddTaskModel> createState() => _AddTaskModelState();
}

class _AddTaskModelState extends State<AddTaskModel> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();


  final TaskController _taskController = Get.put(TaskController());

  DateTime _selectedDate = DateTime.now().subtract(const Duration(days: 1));
  String _startTime= DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime= DateFormat("hh:mm a").format(DateTime.now()).toString() ;
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
      body: Container(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "New Task",
                style: titleStyle,
              ),
              Divider(
                thickness: 1.2,
                color: Colors.grey.shade300,
              ),
              //InputField controls
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(12),
                  Text('Title', style: subTitleStyle),
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
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Enter Task Title',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500
                          )
                      ),
                      controller: _titleController,
                    ),
                  ),

                  const Gap(12),
                  Text('Note', style: subTitleStyle),
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
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Enter note ...',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500
                          )
                      ),
                      maxLines: 3,
                      controller: _noteController,
                    ),
                  ),

                  const Gap(12),
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
                          hintText: 'mm / dd / yy',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500
                          )
                      ),
                      controller: _dateController,
                      onTap: () => _getDateFromUser(),
                    ),
                  ),

                  const Gap(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TimeContainerWidget(
                        titleText: 'Start Time',
                        valueText: _startTime,
                        onTap: () => _getTimeFromUser(isStartTime: true),
                      ),
                      const Gap(12),
                      TimeContainerWidget(
                        titleText: 'End Time',
                        valueText: _endTime,
                        onTap: () => _getTimeFromUser(isStartTime: false),
                      )
                    ],
                  ),

                  const Gap(12),
                  Text('Remind', style: subTitleStyle),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: DropdownButtonFormField<String>(
                      icon: const Visibility(visible: false, child: Icon(Icons.keyboard_arrow_down),),
                      style: const TextStyle(
                          color: Colors.black
                      ),
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: '$_selectedRemind minutes',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500
                          )
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRemind = int.parse(newValue!);
                        });
                      },
                      items: remindList.map<DropdownMenuItem<String>>((int value){
                        return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text('$value minutes', )
                        );
                      }
                      ).toList(),
                    ),

                  ),

                  const Gap(12),
                  Text('Repeat', style: subTitleStyle),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: DropdownButtonFormField<String>(
                      icon: const Visibility(visible: false, child: Icon(Icons.keyboard_arrow_down),),
                      style: const TextStyle(
                          color: Colors.black
                      ),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: _selectedRepeat,
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500
                          )
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRepeat = newValue!;
                        });
                      },
                      items: repeatList.map<DropdownMenuItem<String>>((String? value){
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value!)
                        );
                      }
                      ).toList(),
                    ),

                  ),

                  // Container(
                  //   child: _colorPallet(),
                  // ),

                  const SizedBox(height: 18,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16)
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16)
                          ),
                          onPressed: () => _validateDate(),
                          child: const Text('Create'),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /* Custom Function */

  //Condition to allow adding new data
  _validateDate(){
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty && !_selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      _addTaskToDb();
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return const NavbarRoots();
      }));
    }
    else if (_titleController.text.isNotEmpty || _noteController.text.isNotEmpty && _selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      Get.snackbar("Invalid Date", "Set date should not be at past",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
    else if (_titleController.text.isEmpty || _noteController.text.isEmpty && !_selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      Get.snackbar("Required", "All Title and Notes are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
  }
  // Control to save Data into Database
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
    //print("My id is " "$value");
  }
  //Function that handles Color button
  _colorPallet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Category",
          style: titleStyle,
        ),
        const SizedBox(height: 8.0,),
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
                      child: _selectedColor==index?const Icon(Icons.done,
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

  //Get Date
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
        _dateController.text = DateFormat.yMd().format(_selectedDate);
      });
    }
    else {
      Get.back;
      //print("it's null or somethings is wrong");
    }
  }

  bool _isTimeBefore(String time1, String time2) {
    DateTime dateTime1 = DateFormat("hh:mm a").parse(time1);
    DateTime dateTime2 = DateFormat("hh:mm a").parse(time2);
    return dateTime1.isBefore(dateTime2);
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    if (pickedTime == null) {
      //print("Time cancel");
    } else {
      String formattedTime = pickedTime.format(context);
      if (isStartTime) {
        setState(() {
          _startTime = formattedTime;
          if (_isTimeBefore(_endTime, formattedTime)) {
            _endTime = formattedTime;
          }
        });
      } else {
        setState(() {
          if (_isTimeBefore(formattedTime, _startTime)) {
            _endTime = _startTime;
          } else {
            _endTime = formattedTime;
          }
        });
      }
    }
  }

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

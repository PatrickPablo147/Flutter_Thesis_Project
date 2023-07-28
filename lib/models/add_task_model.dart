/*This class Manage the Adding of Task */
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:project1/controllers/task_controller.dart';
import 'package:project1/ui/theme/theme.dart';
import 'task.dart';

class AddTaskModel extends StatefulWidget {
  const AddTaskModel({Key? key}) : super(key: key);

  @override
  State<AddTaskModel> createState() => _AddTaskModelState();
}

class _AddTaskModelState extends State<AddTaskModel> {
  final TextEditingController _noteController = TextEditingController();

  final TaskController _taskController = Get.put(TaskController());

  var hour = 1;
  var minute = 0;
  var timeFormat = "AM";

  List<String> titleList = [
    "General",
    "Celebration",
    "Exercise",
    "Study",
    "Meeting"
  ];
  int indexValue = 0;
  DateTime _selectedDate = DateTime.now();
  int _selectedRemind = 0;
  List<int> remindList=[2, 5, 10, 20];
  String _selectedRepeat = "None";
  List<String> repeatList=[
    "None",
    "Daily",
    "Weekly",
    "Monthly"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(LineAwesomeIcons.angle_left)
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 80,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                  onPressed: () {
                    _addTaskToDb();
                    _taskController.getTasks();
                  },
                  child: Text('Save', style: textStyle.copyWith(color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 65),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Plan your",
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    letterSpacing: 5
                                  ),
                              ),
                            ),
                            Text(
                              'DAY',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                  color: _getCatColor(indexValue),
                                  height: 0.9,
                                  letterSpacing: -2
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 75, width: 75,
                              child: Image(image: AssetImage("assets/images/${_getTitleIcon(indexValue)}.png"),)
                            ),
                            //const Icon(LineAwesomeIcons.birthday_cake, color: Colors.red, size: 80,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      indexValue = (indexValue - 1 + titleList.length) % titleList.length;
                                    });
                                  },
                                  child: const Icon(LineAwesomeIcons.angle_left, color: Colors.grey,)
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Center(child: Text(titleList[indexValue], style: subTitleStyle,))
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        indexValue = (indexValue + 1 ) % titleList.length;
                                      });
                                    },
                                    child: const Icon(LineAwesomeIcons.angle_right, color: Colors.grey,)
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                //Input controls
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      thickness: 2,
                      color: _getCatColor(indexValue),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date', style: subTitleStyle),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            child: const Icon(LineAwesomeIcons.alternate_calendar_1, size: 25, color: Colors.blueAccent,),
                            onTap: () => _getDateFromUser(),
                          ),
                        ),
                      ],
                    ),
                    _addDateBar(),

                    const Gap(10),
                    Text('Time', style: subTitleStyle),
                    const Gap(3),
                    _addTimeBar(),

                    const Gap(10),
                    Text('Repeat', style: subTitleStyle),
                    const Gap(3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all()
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
                          hintStyle: textStyle
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRepeat = newValue!;
                          });
                        },
                        items: repeatList.map<DropdownMenuItem<String>>((String? value){
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value!, style: textStyle,)
                          );
                        }
                        ).toList(),
                      ),

                    ),


                    const Gap(10),
                    Text('Remind', style: subTitleStyle),
                    const Gap(3),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 5, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: _selectedRepeat == 'None' ? Colors.grey : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all()
                      ),
                      child: Row(
                        children: [
                          Text("For${_getRepeatTitle(_selectedRepeat)} :", style: textStyle,),
                          const Gap(20),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _selectedRepeat == 'None' ?
                                      IgnorePointer(
                                        child: _repeatWidget(),
                                      ) :
                                      _repeatWidget()
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const Gap(10),
                    Text('Note', style: subTitleStyle),
                    const Gap(3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all()
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                            color: Colors.black
                        ),
                        decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Write things to remember ...',
                            hintStyle: textStyle
                        ),
                        maxLines: 6,
                        controller: _noteController,
                      ),
                    ),
                    const Gap(30)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* Custom Function */

  _repeatWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 15,
          children: List<Widget>.generate(remindList.length ,
                  (int index) {
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedRemind = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      width: 35, height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _selectedRemind==index ? _getCatColor(indexValue) : Colors.transparent
                      ),
                      child: Center(
                        child: Text(
                            remindList[index].toString(), style: textStyle.copyWith(color: _selectedRemind == index ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              }
          ),
        )

      ],
    );
  }

  // Control to save Data into Database
  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
          note: _noteController.text,
          title: titleList[indexValue],
          date: DateFormat.yMd().format(_selectedDate),
          startTime: ('$hour:${minute.toString().padLeft(2, '0')} $timeFormat'),
          endTime: "12:00 PM",
          remind: (_selectedRepeat == 'None') ? 0 : remindList[_selectedRemind],
          repeat: _selectedRepeat,
          color: indexValue,
          isCompleted: 0,
        )
    );
    //print("My id is " "$value");
    Get.back();
  }



  _addDateBar() {
    return CalendarTimeline(
      initialDate: _selectedDate,  //DateTime(2020, 4, 20),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040, 11, 20),
      onDateSelected: (date) => setState(() {
        _selectedDate = date;
      }),
      leftMargin: 0,
      monthColor: Colors.black.withOpacity(0.65),
      dayColor: Colors.black.withOpacity(0.65),
      activeDayColor: Colors.white,
      activeBackgroundDayColor: _getCatColor(indexValue),
      dotsColor: Colors.white,//const Color(0xFFFFFFFF).withOpacity(0.8),
      locale: 'en_ISO',
      selectableDayPredicate: null,
    );
  }

  _addTimeBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all()
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SingleChildScrollView(
            child: NumberPicker(
              minValue: 1,
              maxValue: 12,
              value: hour,
              zeroPad: true,
              infiniteLoop: true,
              itemWidth: 70,
              itemHeight: 30,
              onChanged: (value) {
                setState(() {
                  hour = value;
                });
              },
              textStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14
                ),
              ),
              selectedTextStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 17
                ),
              ),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black54
                  ),
                  bottom: BorderSide(
                    color: Colors.black54
                  )
                )
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 24),),
          SingleChildScrollView(
            child: NumberPicker(
              minValue: 0,
              maxValue: 59,
              value: minute,
              zeroPad: true,
              infiniteLoop: true,
              itemWidth: 70,
              itemHeight: 30,
              onChanged: (value) {
                setState(() {
                  minute = value;
                });
              },
              textStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14
                ),
              ),
              selectedTextStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 17
                ),
              ),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Colors.black54
                      ),
                      bottom: BorderSide(
                          color: Colors.black54
                      )
                  )
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      timeFormat = "AM";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,),
                    decoration: BoxDecoration(
                      color: timeFormat == "AM"  ? _getCatColor(indexValue) : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'AM',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: timeFormat == "AM" ? Colors.white : Colors.black54,
                            fontSize: timeFormat == "AM" ? 21 : 18
                        ),
                      )
                    ),
                  ),
                ),
                const Gap(10),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      timeFormat = "PM";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,),
                    decoration: BoxDecoration(
                      color: timeFormat == "PM"  ? _getCatColor(indexValue) : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'PM',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: timeFormat == "PM" ? Colors.white : Colors.black54,
                            fontSize: timeFormat == "PM" ? 21 : 18
                        ),
                      )
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2121)
    );
    if (pickerDate!=null){
      setState(() {
        _selectedDate = pickerDate;
      });
    }
    else {
      //print("it's null or somethings is wrong");
      return null;
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
  _getTitleIcon(int no) {
    switch (no) {
      case 0: return 'general';
      case 1: return 'celebrate';
      case 2: return 'exercise';
      case 3: return 'study';
      case 4: return 'meeting';
    }
  }
  _getRepeatTitle(String title) {
    switch(title) {
      case 'None' : return "";
      case 'Daily' : return " days";
      case 'Weekly' : return " weeks";
      case 'Monthly' : return " months";
    }
  }
}

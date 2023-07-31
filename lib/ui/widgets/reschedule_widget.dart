import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:project1/models/task.dart';
import 'package:project1/pages/navpages/schedule_page.dart';
import '../../controllers/task_controller.dart';
import '../theme/theme.dart';

class RescheduleEvent extends StatefulWidget {
  final Task task;
  const RescheduleEvent({Key? key, required this.task}) : super(key: key);

  @override
  State<RescheduleEvent> createState() => _RescheduleEventState();
}

class _RescheduleEventState extends State<RescheduleEvent> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime selectedDate = DateTime.now();
  int indexValue = 0;
  var hour = 1;
  var minute = 0;
  var timeFormat = "AM";

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
                    _taskController.changeDateTime(widget.task.id!, DateFormat.yMd().format(selectedDate), ('$hour:${minute.toString().padLeft(2, '0')} $timeFormat'));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                  },
                  child: Text('Save', style: textStyle.copyWith(color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Set Date', style: textStyle.copyWith(fontSize: 30,),),
                    Text('and Time', style: textStyle.copyWith(fontSize: 30, height: .6),)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Image(image: AssetImage("assets/images/schedule1.jpg"),)
                      ),
                      Text("Change of plan?, Let's find a new time together", style: textStyle ,),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: _getCatColor(widget.task.title.toString()),
                ),

                const Gap(10),
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

                const Gap(30),
                Text(
                  'Previous Sched: ${DateFormat('MMMM d, y').format(DateFormat('M/d/yyyy').parse(widget.task.date.toString()))} at ${widget.task.startTime}',
                  style: textStyle.copyWith(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addDateBar() {
    return CalendarTimeline(
      initialDate: selectedDate,  //DateTime(2020, 4, 20),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040, 11, 20),
      onDateSelected: (date) => setState(() {
        selectedDate = date;
      }),
      leftMargin: 0,
      monthColor: Colors.black.withOpacity(0.65),
      dayColor: Colors.black.withOpacity(0.65),
      activeDayColor: Colors.white,
      activeBackgroundDayColor: _getCatColor(widget.task.title.toString()),
      dotsColor: Colors.white,//const Color(0xFFFFFFFF).withOpacity(0.8),
      locale: 'en_ISO',
      selectableDayPredicate: null,
    );
  }

  _addTimeBar() {
    if (widget.task.date == DateFormat.yMd().format(DateTime.now())) {
      //hour = DateTime.now().hour;
    }
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
                      color: timeFormat == "AM"  ? _getCatColor(widget.task.title.toString()) : Colors.transparent,
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
                      color: timeFormat == "PM"  ? _getCatColor(widget.task.title.toString()) : Colors.transparent,
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
        selectedDate = pickerDate;
      });
    }
    else {
      //print("it's null or somethings is wrong");
      return null;
    }
  }
  _getCatColor(String titleColor) {
    switch(titleColor) {
      case 'General': return Colors.yellow.shade800;
      case 'Celebration': return Colors.pinkAccent;
      case 'Exercise': return Colors.blue.shade400;
      case 'Study': return Colors.green.shade700;
      case 'Meeting': return Colors.black54;
    }
  }
}

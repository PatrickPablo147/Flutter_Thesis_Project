import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project1/controllers/task_controller.dart';
import 'package:project1/models/task.dart';
import 'package:project1/pages/navpages/schedule_page.dart';
import 'package:project1/ui/theme/theme.dart';
import 'package:project1/ui/widgets/reschedule_widget.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> with TickerProviderStateMixin {
  final _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 5, vsync: this);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage())),
            child: const Icon(LineAwesomeIcons.angle_left)
        ),
        title: Center(child: Text('Archive', style: textStyle.copyWith(fontSize: 18),)),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: Align(
                    alignment: Alignment.center,
                    child: TabBar(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      controller: tabController,
                      labelStyle: textStyle,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blueAccent,
                      indicatorWeight: 4,
                      indicatorSize: TabBarIndicatorSize.label,
                      isScrollable: true,
                      tabs: const [
                        Tab(text: 'All' ),
                        Tab(text: 'Complete',),
                        Tab(text: 'Pending',),
                        Tab(text: 'Date',),
                        Tab(text: 'Time',)
                      ]
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20,),
              //   child: Container(
              //     width: 110,
              //     height: 40,
              //     decoration: const BoxDecoration(
              //       border: Border(
              //         bottom: BorderSide(width: 2, color: Colors.grey)
              //       )
              //     ),
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: Padding(
              //             padding: const EdgeInsets.only(left: 20,),
              //             child: DropdownButtonFormField<String>(
              //               icon: const Visibility(visible: false, child: Icon(Icons.keyboard_arrow_down),),
              //               decoration: InputDecoration(
              //                 suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
              //                 enabledBorder: InputBorder.none,
              //                 focusedBorder: InputBorder.none,
              //                 hintText: _sorting,
              //                 hintStyle: textStyle.copyWith(fontSize: 13)
              //               ),
              //               onChanged: (String? newValue) {
              //                 setState(() {
              //
              //                 });
              //               },
              //               items: sortList.map<DropdownMenuItem<String>>((String? value){
              //                 return DropdownMenuItem<String>(
              //                     value: value,
              //                     child: Text(value!, style: textStyle.copyWith(fontSize: 13),)
              //                 );
              //               }
              //               ).toList(),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TabBarView(
                controller: tabController,
                children: [
                  _showTasks(0),
                  _showTasks(1),
                  _showTasks(2),
                  _showTasks(0),
                  _showTasks(0)
                ]
              ),
            ),
          )
        ],
      ),
    );
  }
  
  _showTasks(int value) {
    List<Task> tasksToShow = List.from(_taskController.taskList); // Create a copy of the taskList.

    // Sort the taskList based on the date if value is 3 (sort by date).
    if (value == 3) {
      tasksToShow.sort((a, b) => (a.date as DateTime).compareTo(b.date as DateTime));
    }

    return Obx(() {
      return ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (_, index) {
          Task task = _taskController.taskList[index];
          switch(value) {
            case 0: return _expansionTile(task);
            case 1: {
              if(task.isCompleted == 1) {
                return _expansionTile(task);
              }
              else {
                return Container();
              }
            }
            case 2: {
              if(task.isCompleted == 0) {
                return _expansionTile(task);
              }
              else {
                return Container();
              }
            }
            case 3: {
              return _expansionTile(task);
            }
            default : {
              return Container();
            }
          }
        },
      );
    });
  }

  _expansionTile(Task task) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey, // Set the border color
              width: 1.0,         // Set the border width
            ),
          ),
          child: ExpansionTile(
            collapsedIconColor: Colors.grey,
            iconColor: Colors.grey,
            collapsedTextColor: Colors.black.withOpacity(0.7),
            textColor: Colors.black,
            childrenPadding: const EdgeInsets.only(left: 50, right: 20),
            leading: SizedBox(
                height: 30, width: 30,
                child: Image(image: AssetImage("assets/images/${_getTitleIcon(task.title!)}.png"),)
            ),
            title: Text(task.title??'', style: textStyle.copyWith(fontSize: 25,),),
            subtitle: Text(task.note??'', style: textStyle,),
            children: [
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(10),
                    Text('Schedule :', style: textStyle),
                    //Gap(2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Time : ', style: textStyle,),
                              const Icon(LineAwesomeIcons.clock, size: 18, color: Colors.blueAccent,),
                              const Gap(5),
                              Text(task.startTime??'', style: textStyle,),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Date : ', style: textStyle,),
                              const Icon(LineAwesomeIcons.calendar_with_week_focus, size: 18, color: Colors.blueAccent,),
                              const Gap(5),
                              Text(DateFormat('MMMM d, y').format(DateFormat.yMd().parse(task.date!)), style: textStyle,),
                            ],
                          ),
                          Row(
                            children: [
                              Text('End   : ', style: textStyle,),
                              const Icon(LineAwesomeIcons.calendar_with_week_focus, size: 18, color: Colors.blueAccent,),
                              const Gap(5),
                              Text(
                                task.repeat == 'None' ? "-" : _getRecurrence(task.repeat!, task),
                                style: textStyle,)
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Gap(10),
                    Text('Status :', style: textStyle,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Remind : ', style: textStyle,),
                              Text(task.repeat??'', style: textStyle,)
                            ],
                          ),
                          Row(
                            children: [
                              Text('Repeat  : ', style: textStyle,),
                              Text(task.remind.toString(), style: textStyle,)
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: task.isCompleted == 1 ? Colors.green :  Colors.blue,
                                    shape: BoxShape.circle
                                ),
                              ),
                              const Gap(5),
                              Text(
                                task.isCompleted == 1 ? "Complete" : "Pending",
                                style: textStyle,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Wrap(
                        spacing: 5,
                        children: [
                          GestureDetector(
                              onTap: (){
                                _taskController.delete(task);
                                //Get.back();
                              },
                              child: const Icon(LineAwesomeIcons.trash, color: Colors.black54,)
                          ),
                          GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RescheduleEvent(task: task)));
                              },
                              child: const Icon(LineAwesomeIcons.edit, color: Colors.blueAccent,)
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getRecurrence(String recur, Task task) {
    switch(recur) {
      case 'None' : return DateFormat('MMM d, y').format(DateFormat.yMd().parse(task.date!));
      case 'Daily' : return DateFormat('MMM d, y').format(DateFormat.yMd().parse(task.date!).add(Duration(days: task.remind!)));
      case 'Weekly' : return DateFormat('MMM d, y').format(DateFormat.yMd().parse(task.date!).add(Duration(days: task.remind! * 7)));
      case 'Monthly' :
        DateTime startDate = DateFormat.yMd().parse(task.date!);
        // Calculate the next month's date based on the recurrence
        DateTime endDate = DateTime(startDate.year, startDate.month + task.remind!, startDate.day);

        // Check if the day of the endDate is greater than the last day of the month
        // If it is, set the end date to the last day of the month
        int lastDayOfMonth = DateTime(endDate.year, endDate.month + 1, 0).day;
        if (endDate.day > lastDayOfMonth) {
          endDate = DateTime(endDate.year, endDate.month, lastDayOfMonth);
        }
        return DateFormat('MMM d, y').format(endDate);
    }
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
}

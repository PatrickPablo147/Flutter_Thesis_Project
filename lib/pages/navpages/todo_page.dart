import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:project1/controllers/task_controller.dart';
import 'package:project1/models/task.dart';
import 'package:project1/ui/widgets/build_task_widget.dart';

import '../../ui/widgets/all_task_widget.dart';
import '../../ui/widgets/task_info.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _taskController = Get.put(TaskController());
  int _buttonIndex = 0;
  final _scheduleWidgets = [
    const AllSchedule(),
    //const CompletedSchedule(),
    //const PendingSchedule()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none
                ),
                hintText: "Search a task",
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.grey.withOpacity(0.5)
              ),
            ),
          ),
          const Gap(5),
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              //color: Color(0xFF),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      _buttonIndex = 0;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: MediaQuery.of(context).size.width / 20),
                    decoration: BoxDecoration(
                      color: _buttonIndex == 0 ? Colors.blue.shade800 : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "All",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _buttonIndex == 0 ? Colors.white : Colors.black38
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      _buttonIndex = 1;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: MediaQuery.of(context).size.width / 20),
                    decoration: BoxDecoration(
                      color: _buttonIndex == 1 ? Colors.blue.shade800 : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Completed",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _buttonIndex == 1 ? Colors.white : Colors.black38
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      _buttonIndex = 2;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: MediaQuery.of(context).size.width / 20),
                    decoration: BoxDecoration(
                      color: _buttonIndex == 2 ? Colors.blue.shade800 : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Pending",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _buttonIndex == 2 ? Colors.white : Colors.black38
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //_scheduleWidgets[_buttonIndex]
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _showTasks(_buttonIndex),
            )
          )
        ],
      ),
    );
  }

  _showTasks(int value){
    _taskController.getTasks();
    return Obx((){
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index){
            Task task = _taskController.taskList[index];
            switch(value) {
              case 0: {
                return buildTaskInfoWidget(context, task, index, _taskController);
              }//break;
              case 1: {
                if (task.isCompleted == 1) {
                  return buildTaskInfoWidget(context, task, index, _taskController);
                }
                else {
                  return Container();
                }
              }//break;
              case 2: {
                if (task.isCompleted == 0) {
                  return buildTaskInfoWidget(context, task, index, _taskController);
                } else {
                  return Container();
                }
              }break;
              default: {
                return Container();
              }
            }

          }
      );
    });
  }
}

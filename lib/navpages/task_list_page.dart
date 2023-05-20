import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks(){
    _taskController.getTasks();
    return Expanded(
      child: Obx((){
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index){
              Task task = _taskController.taskList[index];
              //return TaskTile(task);
              return Card(
                elevation: 0,
                child: ExpansionTile(
                  childrenPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  expandedAlignment: Alignment.topLeft,
                  title: Row(
                    children: [
                      Text(task.toJson()['title'],),
                      const Spacer(),
                      Text(task.toJson()['date'],),
                    ],
                  ),
                  children: [
                    Text(
                      task.toJson()['note'],
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      task.toJson()['isCompleted'] == 1 ? "COMPLETED" : "MISSING"
                    )
                  ],
                ),
              );
            }
        );
      }),
    );
  }
}

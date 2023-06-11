import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:project1/ui/widgets/task_info.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';

class AllSchedule extends StatefulWidget {
  const AllSchedule({Key? key}) : super(key: key);

  @override
  State<AllSchedule> createState() => _AllScheduleState();
}

class _AllScheduleState extends State<AllSchedule> {
  final _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "All Schedule",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(12),
            Expanded(
              child: _showTasks(),
            )
          ],
        ),
      ),
    );
  }

  _showTasks(){
    _taskController.getTasks();
    return Obx((){
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _taskController.taskList.length,
        itemBuilder: (_, index){
          Task task = _taskController.taskList[index];
          //print(task.toJson());
          return AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              child: FadeInAnimation(
                child: Row(
                  children: [
                    Expanded(child: TaskInfo(task))
                  ],
                ),
              ),
            ),
          );
        }

      );
    });
  }
}

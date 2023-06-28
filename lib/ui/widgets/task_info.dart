import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';

class TaskInfo extends StatelessWidget {
  final Task? task;
  TaskInfo(this.task, {super.key});
  final _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2
          )
        ]
      ),
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task?.title??"",
                  style: const TextStyle(
                    color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  task?.date??"",
                  style: const TextStyle(
                      color: Colors.black54,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
            subtitle: Text(task?.note??"", style: const TextStyle(color: Colors.black87),),

            // trailing: CircleAvatar(
            //   radius: 25,
            //   //backgroundImage: AssetImage(""),
            // ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              color: Colors.black12,
              thickness: 1,
              height: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_filled,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${task!.startTime} - ${task!.endTime}",
                      style: const TextStyle(
                          color: Colors.black54
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: task!.isCompleted == 1 ? Colors.green : Colors.red,
                        //color: Colors.green,
                          shape: BoxShape.circle
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      task!.isCompleted == 1 ? "COMPLETED" : "PENDING",
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    )
                ],
                )
              ],
            ),
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  _taskController.delete(task!);
                },
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF4F6FA),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Center(
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade800,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Center(
                    child: Text(
                      "Reschedule",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const Gap(10),

        ],
      ),
    );
  }
}

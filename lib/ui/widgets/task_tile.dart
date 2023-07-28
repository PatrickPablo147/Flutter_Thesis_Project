import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/task.dart';
import '../theme/theme.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  const TaskTile(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
          //borderRadius: BorderRadius.circular(8),
          color: Colors.transparent
        //color: _getBGClr(task?.color??0),
      ),
      child: Container(
        //padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          //border: Border.all(color: Colors.black),
          color: Colors.transparent
          //color: _getBGClr(task?.color??0),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 35,
              width: 90,
              color: Colors.green,
              // decoration: const BoxDecoration(
              //   border: Border(
              //     right: BorderSide(color: Colors.black, width: 1)
              //   )
              // ),
              child: Image(
                image: AssetImage("assets/images/${_getTitleIcon(task!.color ?? 0)}.png"),
              )
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8)
                ),
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(5),
                    Text(
                      task?.title??"",
                      style: textStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      task?.note??"",
                      style: textStyle
                    ),

                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time_filled,
                          color: Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "${task!.startTime}",// - ${task!.endTime}",
                          style: textStyle
                        ),
                      ],
                    ),
                    Gap(5),
                  ],
                ),
              ),
            ),

          //   RotatedBox(
          //   quarterTurns: 3,
          //   child: Text(
          //     task!.isCompleted == 1 ? "COMPLETED" : "TODO",
          //     style: GoogleFonts.lato(
          //       textStyle: const TextStyle(
          //           fontSize: 10,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.blueAccent),
          //     ),
          //   ),
          // ),
        ]),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return Colors.white;
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
}
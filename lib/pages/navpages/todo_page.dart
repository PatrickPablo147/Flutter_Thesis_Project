import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:project1/ui/widgets/all_task_widget.dart';
import 'package:project1/ui/widgets/completed_task_widget.dart';
import 'package:project1/ui/widgets/pending_task_widget.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  int _buttonIndex = 0;
  final _scheduleWidgets = [
    const AllSchedule(),
    const CompletedSchedule(),
    const PendingSchedule()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Gap(10),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 15),
          //   child: Text(
          //     "Task List",
          //     style: TextStyle(
          //         fontSize: 30,
          //         fontWeight: FontWeight.w500
          //     ),
          //   ),
          // ),

          const Gap(5),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            color: Colors.transparent,
            child: Center(
                child: Row(
                  children: const [
                    Gap(50),
                    Icon(Icons.search),
                    Text(
                      "Search",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                      ),
                    ),
                  ],
                )
            ),
          ),
          const Gap(20),
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF),
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
                      borderRadius: BorderRadius.circular(20),
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
                      borderRadius: BorderRadius.circular(20),
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
                      borderRadius: BorderRadius.circular(20),
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

          _scheduleWidgets[_buttonIndex],
        ],
      ),
    );
  }
}

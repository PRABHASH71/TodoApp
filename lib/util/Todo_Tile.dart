import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:todoapp/data/database.dart';

class Todotile extends StatefulWidget {
  final String TaskName;
  final String TaskDate;
  final String TaskTime;

  final bool taskCompleted;
  final int index;
  final double percent1;

  Function(double)? updatepercentage;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Todotile(
      {required this.TaskName,
      required this.TaskDate,
      required this.TaskTime,
      required this.percent1,
      required this.updatepercentage,
      required this.taskCompleted,
      required this.onChanged,
      required this.index,
      required this.deleteFunction,
      super.key});

  @override
  State<Todotile> createState() => _TodotileState();
}

class _TodotileState extends State<Todotile> {
  @override
  void initState() {
    value();
    super.initState();
  }

  int val = 0;
  void value() {
    setState(() {
      val = widget.percent1.ceil() * 100;
    });
  }

  void updateit() {
    setState(() {
      double percentage = widget.percent1 + 0.1;
      widget.updatepercentage!(percentage);
      val = widget.percent1.ceil() * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            onPressed: widget.deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(12),
          )
        ]),
        child: InkWell(
          onTap: () {
            updateit();
          },
          child: Container(
            height: 100,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  value: widget.taskCompleted,
                  onChanged: widget.onChanged,
                  activeColor: Colors.green,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.TaskName.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          decoration: (widget.taskCompleted == true)
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.TaskDate.toString(),
                          style: TextStyle(
                              color: Color.fromARGB(255, 42, 42, 42),
                              fontSize: 12,
                              decoration: TextDecoration.none),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          widget.TaskTime.toString(),
                          style: TextStyle(
                              color: Color.fromARGB(255, 42, 42, 42),
                              fontSize: 12,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                CircularPercentIndicator(
                  radius: 27,
                  center: Text(
                    (widget.percent1 * 100).ceil().toString() + "%",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  percent: widget.percent1,
                  animation: true,
                  animationDuration: 800,
                  progressColor: Colors.blue,
                  backgroundColor: Color.fromARGB(255, 255, 0, 0),
                  circularStrokeCap: CircularStrokeCap.round,
                  lineWidth: 10.0,
                ),
              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.yellow,
                      Colors.yellow,
                    ])),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/NotificationPluggin/NotificationApi.dart';
import 'package:todoapp/util/buttons.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller;

  final Function(String, String)? onSave;
  final VoidCallback onCancel;

  const DialogBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  DateTime _date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  void _showdatepicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2030))
        .then((value) {
      setState(() {
        _date = value!;
      });
    });
  }

  void _showtimepicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        time = value!;
      });
    });
  }

  void saveit() {
    final _time = Duration(hours: time.hour, minutes: time.minute);

    String st = DateFormat.yMMMEd().format(_date).toString();
    String t = time.format(context).toString();

    final inittime = Duration(
        hours: _date.hour, minutes: _date.minute, seconds: _date.second);

    _date = _date.subtract(inittime);

    NotificationApi.showNotification(
        title: widget.controller.text.toString(),
        body: "Please Complete your tasks",
        payload: "Prabhash.Ranjan",
        Scheduledate: _date.add(_time));

    widget.onSave!(st, t);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber,
      content: Container(
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              textAlign: TextAlign.justify,
              maxLength: 24,
              controller: widget.controller,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.abc,
                  color: Color.fromARGB(255, 72, 72, 72),
                ),
                fillColor: Colors.yellow,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12)),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12)),
                hintText: "Add a new Task",
                hintStyle: TextStyle(color: Color.fromARGB(255, 72, 72, 72)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _showdatepicker();
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        "Add Date",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Text(DateFormat.yMMMEd().format(_date).toString()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _showtimepicker();
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        "Add Time",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Text(time.format(context).toString()),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton(widget.onCancel, "Cancel"),
                MaterialButton(
                  onPressed: () {
                    saveit();
                  },
                  color: Colors.blue,
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

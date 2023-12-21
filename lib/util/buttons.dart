import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  MyButton(
    this.onPressed,
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: (text == "Cancel") ? Colors.red : Colors.blue,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

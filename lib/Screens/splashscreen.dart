import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:lottie/lottie.dart';

import 'package:todoapp/Screens/Homepage.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 3600), (() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      Fluttertoast.showToast(msg: "Task Completed Successfully : )");
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          height: 700,
          width: 900,
          child: Lottie.network(
            // "https://lottie.host/3661c27d-da6f-4784-9bc9-bf2f2d9e51b9/5yqLSipDdz.json",
            "https://lottie.host/28f4ed5a-e0a2-4524-9f57-182ce9fbe420/3Zr6uNeFXa.json",
            frameRate: FrameRate.max,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:timezone/standalone.dart';
import 'package:todoapp/Screens/Homepage.dart';
import 'package:todoapp/NotificationPluggin/NotificationApi.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  NotificationApi().initNotification();
  await Hive.initFlutter();
  var box = await Hive.openBox('mybox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: HomePage(),
    );
  }
}

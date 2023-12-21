import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    _notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('ic_launcher');

    var initializationsettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _notification.initialize(initializationsettings,
        onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse notificationresponse) async {});
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          icon: "ic_launcher", importance: Importance.max),
    );
  }

  static Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime Scheduledate}) async {
    return _notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(Scheduledate, tz.local),
      await _notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

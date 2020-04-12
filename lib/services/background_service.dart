import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ui_clock_and_alarm/models/alarm_model.dart';
import 'package:ui_clock_and_alarm/services/alarms_database.dart';

class BackgroundService {
  static Duration firstRun = Duration(days: 8);
  static AlarmModel firstAlarm;
  static DateTime nextAlarmDateTime;

  static Future<void> scheduleAlarm() async {
    firstAlarm = await checkNextAlarm();
    // if (firstAlarm != null) {
    //   Future.delayed(firstRun).then((v) async {
    //     await audioPlayer.play(firstAlarm.audioPath, isLocal: true);
    //     AppAvailability.launchApp("com.mahmoud.alarmy").then((v) {
    //       print("AppAvailability");
    //       Navigator.pushReplacement(AlarmsScreen.alarmsScreenContext,
    //           MaterialPageRoute(builder: (c) => AlarmTimeScreen(firstAlarm)));
    //     });
    //   });
//      print("local Notification");
//      var scheduledNotificationDateTime = nextAlarmDateTime;
//      var vibrationPattern = Int64List(4);
//      vibrationPattern[0] = 0;
//      vibrationPattern[1] = 1000;
//      vibrationPattern[2] = 5000;
//      vibrationPattern[3] = 2000;
//      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//        'channel-id',
//        'channel-name',
//        'channel-description',
//        importance: Importance.Max,
//        priority: Priority.Max,
//        playSound: false,
//        enableVibration: true,
//        vibrationPattern: vibrationPattern,
//      );
//      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//      NotificationDetails platformChannelSpecifics = NotificationDetails(
//          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//      await flutterLocalNotificationsPlugin.schedule(
//        firstAlarm.id,
//        firstAlarm.label,
//        "Alarm App",
//        scheduledNotificationDateTime,
//        platformChannelSpecifics,
//        androidAllowWhileIdle: true,
//      );
    // }
  }

  static Future<AlarmModel> checkNextAlarm() async {
    AlarmModel nextAlarm;
    List<AlarmModel> _alarms = await fetchDateBaseAlarms();
    for (var alarm in _alarms) {
      // DateTime alarmTime = DateTime.parse(alarm.alarmTime);
      // for (final alarmDay in alarm.alarmDays.split("")) {
      // if (alarmTime.add(Duration(days: alarmDay)).isAfter(DateTime.now())) {
      //   if (firstRun >
      //       alarmTime
      //           .add(Duration(days: alarmDay))
      //           .difference(DateTime.now())) {
      //     if (alarm.active == 1) {
      //       firstRun = alarmTime
      //           .add(Duration(days: alarmDay))
      //           .difference(DateTime.now());
      //       nextAlarm = alarm;
      //       nextAlarmDateTime = alarmTime.add(Duration(days: alarmDay));
      //     }
      //   }
      // } else {
      //   nextAlarm = null;
      // }
      // }
    }
    return nextAlarm;
  }

  static Future<List<AlarmModel>> fetchDateBaseAlarms() async {
    List<AlarmModel> _alarms = [];
    AlarmsDataBase _alarmsDb = AlarmsDataBase();
    List<Map<String, dynamic>> _allAlarms = await _alarmsDb.getAllItem();
    _allAlarms.forEach((alarm) {
      return _alarms.add(AlarmModel.fromObj(alarm));
    });
    return _alarms;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:morning/models/alarm_model.dart';
import 'package:morning/services/alarm_database.dart';
import 'package:morning/services/douban_fm.dart';

class AlarmProvider with ChangeNotifier {
  static final AlarmProvider _instance = AlarmProvider._internal();

  factory AlarmProvider() {
    return _instance;
  }

  AlarmProvider._internal() {
    this._fetchAlarms();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _checkAlarm());
  }

  DoubanFm fm = new DoubanFm();
  AlarmDataBase _dataBase = AlarmDataBase();
  List<AlarmModel> alarms = [];

  DateTime nextAlarmTime;
  List<AlarmModel> nextAlarmList;
  bool alarmOn = false;

  turnOffAlarm() {
    fm.stop();
    alarmOn = false;
    notifyListeners();
  }

  Future<int> getNewAlarmId() async {
    //use the existing alarms to find the lowest empty id
    List<AlarmModel> _alarms = await _fetchDateBaseAlarms();
    final List<int> alarmIds =
        _alarms.map((AlarmModel alarm) => alarm.id).toList(growable: false);
    int id = 0;
    while (alarmIds.contains(id)) {
      id++;
    }
    return id;
  }

  _scheduleAlarm() {
    List<AlarmModel> activeAlarms =
        alarms.where((alarm) => alarm.active == 1).toList();
    DateTime alarmTime;
    List<AlarmModel> alarmList;
    activeAlarms.forEach((a) {
      DateTime earliestAlarm = _getNextAlarm(a);
      if (alarmTime == null || earliestAlarm.isBefore(alarmTime)) {
        alarmTime = earliestAlarm;
        alarmList = [a];
      } else if (earliestAlarm.isAtSameMomentAs(alarmTime)) {
        alarmList.add(a);
      }
    });
    nextAlarmTime = alarmTime;
    nextAlarmList = alarmList;
  }

  void addAlarm(AlarmModel alarmModel) async {
    alarms.add(alarmModel);
    _sortAlarms();
    notifyListeners();
    _scheduleAlarm();
    await _dataBase.saveAlarm(alarmModel);
  }

  void updateAlarm(AlarmModel alarmModel, int index) async {
    alarms[index] = alarmModel;
    _sortAlarms();
    notifyListeners();
    _scheduleAlarm();
    await _dataBase.updateItem(alarmModel.id, alarmModel);
  }

  void deleteAlarm(id, index) async {
    alarms.removeAt(index);
    notifyListeners();
    _scheduleAlarm();
    await _dataBase.deleteItem(id);
  }

  void updateAlarmStatus(id) async {
    AlarmModel alarm = alarms.firstWhere((a) => a.id == id);
    alarm.active = 1 - alarm.active;
    notifyListeners();
    _scheduleAlarm();
    await _dataBase.updateItem(id, alarm);
  }

  _fetchAlarms() async {
    alarms = await _fetchDateBaseAlarms();
    _sortAlarms();
    notifyListeners();
    _scheduleAlarm();
  }

  _sortAlarms() {
    alarms.sort((a, b) => a.alarmTime.compareTo(b.alarmTime));
  }

  Future<List<AlarmModel>> _fetchDateBaseAlarms() async {
    List<AlarmModel> _alarms = [];
    List<Map<String, dynamic>> _allAlarms = await _dataBase.getAllItem();
    _allAlarms.forEach((alarm) {
      return _alarms.add(AlarmModel.fromObj(alarm));
    });
    return _alarms;
  }

  bool _isAlarmOneTime(AlarmModel alarm) {
    return int.parse(alarm.alarmDays) == 0;
  }

  DateTime _getNextAlarm(AlarmModel alarm) {
    DateTime today = DateTime.now();
    if (!_isAlarmOneTime(alarm)) {
      // repeated alarm
      int weekday = today.weekday;
      for (var i = 0; i < 8; i++) {
        if (alarm.alarmDays[(i + weekday) % 7] == '1') {
          if (i == 0 &&
              _constructTime(int.parse(alarm.alarmTime.substring(2, 4)),
                      int.parse(alarm.alarmTime.substring(0, 2)))
                  .isAfter(today)) {
            return _constructTime(
              int.parse(alarm.alarmTime.substring(2, 4)),
              int.parse(alarm.alarmTime.substring(0, 2)),
            );
          }
          if (i > 0) {
            return _constructTime(int.parse(alarm.alarmTime.substring(2, 4)),
                int.parse(alarm.alarmTime.substring(0, 2)), today.day + i);
          }
        }
      }
    } else {
      if (_constructTime(int.parse(alarm.alarmTime.substring(2, 4)),
              int.parse(alarm.alarmTime.substring(0, 2)))
          .isAfter(today)) {
        return _constructTime(
          int.parse(alarm.alarmTime.substring(2, 4)),
          int.parse(alarm.alarmTime.substring(0, 2)),
        );
      } else {
        return _constructTime(int.parse(alarm.alarmTime.substring(2, 4)),
            int.parse(alarm.alarmTime.substring(0, 2)), today.day + 1);
      }
    }
    return null;
  }

  DateTime _constructTime(int min, int hr, [int day]) {
    DateTime n = DateTime.now();
    return DateTime(n.year, n.month, day ?? n.day, hr, min);
  }

  void _checkAlarm() {
    DateTime now = DateTime.now();

    if (nextAlarmTime != null) {
      int diffSeconds = nextAlarmTime.difference(now).inSeconds;

      // print('Next alarm: $nextAlarmTime');
      // print('Countdown: $diffSeconds');

      if (diffSeconds == 0) {
        fm.play();
        alarmOn = true;
        _deactivateAlarms(nextAlarmList);
        _scheduleAlarm();
      }
    }
  }

  void _deactivateAlarms(List<AlarmModel> alarmList) {
    alarmList.forEach((alarm) {
      if (_isAlarmOneTime(alarm)) {
        updateAlarmStatus(alarm.id);
      }
    });
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ui_clock_and_alarm/models/alarm_model.dart';
import 'package:ui_clock_and_alarm/services/alarms_database.dart';

class AlarmProvider with ChangeNotifier {
  AlarmsDataBase _dataBase = AlarmsDataBase();
  List<AlarmModel> alarms = [];

  AlarmProvider() {
    this._fetchAlarms();
  }

  _fetchAlarms() async {
    alarms = await fetchDateBaseAlarms();
    _sortAlarms();
    notifyListeners();
  }

  _sortAlarms() {
    alarms.sort((a, b) => a.alarmTime.compareTo(b.alarmTime));
  }

  Future<List<AlarmModel>> fetchDateBaseAlarms() async {
    List<AlarmModel> _alarms = [];
    List<Map<String, dynamic>> _allAlarms = await _dataBase.getAllItem();
    _allAlarms.forEach((alarm) {
      return _alarms.add(AlarmModel.fromObj(alarm));
    });
    return _alarms;
  }

  Future<int> getNewAlarmId() async {
    //use the existing alarms to find the lowest empty id
    List<AlarmModel> _alarms = await fetchDateBaseAlarms();
    final List<int> alarmIds =
        _alarms.map((AlarmModel alarm) => alarm.id).toList(growable: false);
    int id = 0;
    while (alarmIds.contains(id)) {
      id++;
    }
    return id;
  }

  Future<void> scheduleAlarm() async {}

  void addAlarm(AlarmModel alarmModel) async {
    alarms.add(alarmModel);
    _sortAlarms();
    await _dataBase.saveAlarm(alarmModel);

    notifyListeners();
    scheduleAlarm();
  }

  void updateAlarm(AlarmModel alarmModel, int index) async {
    alarms[index] = alarmModel;
    _sortAlarms();
    notifyListeners();
    scheduleAlarm();
    await _dataBase.updateItem(alarmModel.id, alarmModel);
  }

  void deleteAlarm(id, index) async {
    alarms.removeAt(index);
    notifyListeners();
    await _dataBase.deleteItem(id);
  }

  void updateAlarmStatus(id, index) async {
    if (alarms[index].active == 0) {
      alarms[index].active = 1;
    } else {
      alarms[index].active = 0;
    }
    await _dataBase.updateItem(id, alarms[index]);
    notifyListeners();
  }
}

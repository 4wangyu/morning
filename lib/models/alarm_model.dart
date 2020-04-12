import 'package:flutter/material.dart';

class AlarmModel {
  int id;
  String alarmTime;
  String alarmDays;
  int active;

  AlarmModel({
    @required this.id,
    @required this.alarmTime,
    @required this.alarmDays,
    this.active = 1,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = this.id;
    map["alarmtime"] = this.alarmTime;
    map["active"] = this.active;
    map["alarmdays"] = this.alarmDays;
    return map;
  }

  AlarmModel.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.alarmDays = map["alarmdays"];
    this.alarmTime = map["alarmtime"];
    this.active = map["active"];
  }

  AlarmModel.fromObj(dynamic obj) {
    this.id = obj["id"];
    this.alarmDays = obj["alarmdays"];
    this.alarmTime = obj["alarmtime"];
    this.active = obj["active"];
  }
}

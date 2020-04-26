import 'package:flutter/material.dart';
import 'package:morning/theme.dart';

Widget circleDay(day, context, selected, setAlarmDay, dayIdx) {
  return GestureDetector(
    child: Container(
        width: 44.0,
        height: 44.0,
        decoration: BoxDecoration(
            color: (selected) ? accentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(22.0)),
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Center(
            child: Text(
              day,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        )),
    onTap: () => setAlarmDay(selected ? '0' : '1', dayIdx),
  );
}

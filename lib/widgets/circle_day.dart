import 'package:flutter/material.dart';

Widget circleDay(day, context, selected, setAlarmDay, dayIdx) {
  return GestureDetector(
    child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
            color:
                (selected) ? Theme.of(context).accentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(100.0)),
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Center(
            child: Text(
              day,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        )),
    onTap: () => setAlarmDay(selected ? '0' : '1', dayIdx),
  );
}

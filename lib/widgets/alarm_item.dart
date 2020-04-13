import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_clock_and_alarm/models/alarm_model.dart';

class AlarmItem extends StatelessWidget {
  final AlarmModel alarm;

  AlarmItem(this.alarm);

  TimeOfDay _getTimeOfDay() {
    return TimeOfDay(
        hour: int.parse(alarm.alarmTime.substring(0, 2)),
        minute: int.parse(alarm.alarmTime.substring(2, 4)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 17),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _getTimeOfDay().format(context),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SourceSansPro'),
                  ),
                  Row(
                    children: int.parse(alarm.alarmDays) > 0
                        ? <Widget>[
                            dayOfWeek('Sun', alarm.alarmDays[0]),
                            dayOfWeek('Mon', alarm.alarmDays[1]),
                            dayOfWeek('Tue', alarm.alarmDays[2]),
                            dayOfWeek('Wed', alarm.alarmDays[3]),
                            dayOfWeek('Thu', alarm.alarmDays[4]),
                            dayOfWeek('Fri', alarm.alarmDays[5]),
                            dayOfWeek('Sat', alarm.alarmDays[6]),
                          ]
                        : <Widget>[dayOfWeek('Once', '1')],
                  ),
                ],
              ),
              CupertinoSwitch(
                value: alarm.active == 1,
                onChanged: (bool val) {
                  print(val);
                },
                activeColor: Color(0xff65D1BA),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 1.0,
            width: double.maxFinite,
            child: Container(
              color: Colors.white30,
            ),
          )
        ],
      ),
    );
  }
}

Widget dayOfWeek(String text, String selected) {
  return selected == '1'
      ? Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w600),
          ),
        )
      : SizedBox.shrink();
}

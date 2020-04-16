import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_clock_and_alarm/models/alarm_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ui_clock_and_alarm/services/alarm_provider.dart';

class AlarmItem extends StatelessWidget {
  final AlarmModel alarm;
  final int alarmIndex;

  AlarmItem(this.alarm, this.alarmIndex);

  TimeOfDay _getTimeOfDay() {
    return TimeOfDay(
        hour: int.parse(alarm.alarmTime.substring(0, 2)),
        minute: int.parse(alarm.alarmTime.substring(2, 4)));
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, left: 17, right: 17),
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
                    alarmProvider.updateAlarmStatus(alarm.id);
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
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Update',
          color: Color(0xff65D1BA),
          icon: Icons.create,
          onTap: () => Navigator.pushNamed(context, '/add-update-alarm',
              arguments: UpdateAlarmArguments(alarm, alarmIndex)),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => alarmProvider.deleteAlarm(alarm.id, alarmIndex),
        ),
      ],
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

class UpdateAlarmArguments {
  final AlarmModel alarm;
  final int alarmIndex;

  UpdateAlarmArguments(this.alarm, this.alarmIndex);
}

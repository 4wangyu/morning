import 'package:flutter/material.dart';
import 'package:morning/theme.dart';
import 'package:provider/provider.dart';
import 'package:morning/models/alarm_model.dart';
import 'package:morning/services/alarm_provider.dart';
import 'package:morning/widgets/alarm_item.dart';
import 'package:morning/widgets/circle_day.dart';

class AddUpdateAlarm extends StatefulWidget {
  AddUpdateAlarm({Key key}) : super(key: key);

  _AddUpdateAlarmState createState() => _AddUpdateAlarmState();
}

class _AddUpdateAlarmState extends State<AddUpdateAlarm> {
  TimeOfDay _selectedTime;
  List<String> alarmDays = List.filled(7, '0');
  AlarmModel alarm;
  int alarmIndex;

  @override
  void initState() {
    _selectedTime = TimeOfDay.now();
    super.initState();
  }

  setAlarmDay(String status, num idx) {
    setState(() {
      alarmDays[idx] = status;
    });
  }

  String _formatTimeOfDay() {
    return _selectedTime.hour.toString().padLeft(2, '0') +
        _selectedTime.minute.toString().padLeft(2, '0');
  }

  bool get _isUpdate {
    return alarm != null;
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);
    final UpdateAlarmArguments args = ModalRoute.of(context).settings.arguments;
    if (args != null && alarm == null) {
      alarm = args.alarm;
      alarmIndex = args.alarmIndex;

      _selectedTime = TimeOfDay(
          hour: int.parse(alarm.alarmTime.substring(0, 2)),
          minute: int.parse(alarm.alarmTime.substring(2, 4)));

      alarmDays = alarm.alarmDays.split('');
    }

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Column(
          children: <Widget>[
            Icon(
              Icons.alarm_add,
              color: accentColor,
            ),
            Text(_isUpdate ? 'Update Alarm' : 'Add Alarm',
                style: TextStyle(color: accentColor, fontSize: 25.0))
          ],
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 60.0,
                ),
                new GestureDetector(
                  child: Text(
                    _selectedTime.format(context),
                    style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    _selectTime(context);
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    circleDay(
                        'Sun', context, alarmDays[0] == '1', setAlarmDay, 0),
                    circleDay(
                        'Mon', context, alarmDays[1] == '1', setAlarmDay, 1),
                    circleDay(
                        'Tue', context, alarmDays[2] == '1', setAlarmDay, 2),
                    circleDay(
                        'Wed', context, alarmDays[3] == '1', setAlarmDay, 3),
                    circleDay(
                        'Thu', context, alarmDays[4] == '1', setAlarmDay, 4),
                    circleDay(
                        'Fri', context, alarmDays[5] == '1', setAlarmDay, 5),
                    circleDay(
                        'Sat', context, alarmDays[6] == '1', setAlarmDay, 6),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 2.0,
                  child: Container(
                    color: Colors.white30,
                  ),
                ),
                SizedBox(
                  height: 60.0,
                ),
                FlatButton(
                    color: accentColor,
                    child: Text('Save',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: () async {
                      if (_isUpdate) {
                        alarmProvider.updateAlarm(
                            AlarmModel(
                              id: alarm.id,
                              alarmTime: _formatTimeOfDay(),
                              alarmDays: alarmDays.join(''),
                            ),
                            alarmIndex);
                      } else {
                        alarmProvider.addAlarm(AlarmModel(
                          id: await alarmProvider.getNewAlarmId(),
                          alarmTime: _formatTimeOfDay(),
                          alarmDays: alarmDays.join(''),
                        ));
                      }

                      Navigator.of(context).pop();
                    })
              ],
            ),
          )),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _selectedTime);

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
}

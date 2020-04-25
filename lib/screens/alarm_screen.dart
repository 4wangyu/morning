import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morning/services/alarm_provider.dart';
import 'package:morning/theme.dart';
import 'package:morning/widgets/slider.dart';

class AlarmScreen extends StatelessWidget {
  final AlarmProvider alarmProvider = AlarmProvider();

  AlarmScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final format = DateFormat().add_jm();

    return Scaffold(
        body: Container(
            color: primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 325,
                    height: 325,
                    decoration: ShapeDecoration(
                        shape: CircleBorder(
                            side: BorderSide(
                                color: accentColor,
                                style: BorderStyle.solid,
                                width: 4))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.alarm,
                          color: accentColor,
                          size: 32,
                        ),
                        Text(
                          format.format(now),
                          style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                        Text(
                          'Alarm',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: SliderButton(
                    backgroundColor: accentColor,
                    width: 230,
                    icon: Center(
                        child: Icon(
                      Icons.chevron_right,
                      size: 40,
                    )),
                    label: Text(
                      'Turn off alarm !',
                      style: TextStyle(color: primaryColor, fontSize: 26),
                    ),
                    action: () async {
                      alarmProvider.turnOffAlarm();
                      print(alarmProvider.alarmOn);
                    },
                  ),
                )
              ],
            )));
  }
}

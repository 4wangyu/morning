import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morning/services/alarm_provider.dart';
import 'package:morning/theme.dart';
import 'package:morning/widgets/slider.dart';
import 'package:provider/provider.dart';

class AlarmScreen extends StatelessWidget {
  final format = DateFormat().add_jm();
  final now = DateTime.now()
      .add(Duration(seconds: 4)); // make sure the display time is correct

  AlarmScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);

    return Scaffold(
        body: Container(
            color: primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
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
                        child: Icon(Icons.chevron_right,
                            size: 40, color: primaryColor)),
                    label: Text(
                      'Turn off !',
                      style: TextStyle(color: primaryColor, fontSize: 26),
                    ),
                    action: () async {
                      alarmProvider.turnOffAlarm();
                    },
                  ),
                )
              ],
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui_clock_and_alarm/add_alarm.dart';
import 'package:ui_clock_and_alarm/radio.dart';

import 'app_config.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String env = 'dev';
  final config = await AppConfig.forEnvironment(env);

  RadioGaGa radio = new RadioGaGa();
  radio.getFileList();
  // pass our config to our app
  runApp(AlarmApp(config));
}

class AlarmApp extends StatefulWidget {
  var config;
  AlarmApp(this.config);

  _AlarmAppState createState() => _AlarmAppState(this.config);
}

class _AlarmAppState extends State<AlarmApp> {
  var config;

  _AlarmAppState(this.config);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/add-alarm': (context) => AddAlarm(),
        },
        theme: ThemeData(
            fontFamily: 'SourceSansPro',
            primaryColor: Color(0xff1B2C57),
            accentColor: Color(0xff65D1BA)),
        debugShowCheckedModeBanner: false,
        home: Home());
  }
}

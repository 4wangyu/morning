import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morning/screens/add_update_alarm.dart';
import 'package:morning/services/alarm_provider.dart';
import 'package:morning/theme.dart';
import 'package:provider/provider.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AlarmApp());
}

class AlarmApp extends StatefulWidget {
  AlarmApp();

  _AlarmAppState createState() => _AlarmAppState();
}

class _AlarmAppState extends State<AlarmApp> {
  _AlarmAppState();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: AlarmProvider()),
        ],
        child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/add-update-alarm': (context) => AddUpdateAlarm(),
            },
            theme: ThemeData(
                fontFamily: 'SourceSansPro',
                primaryColor: primaryColor,
                accentColor: accentColor),
            debugShowCheckedModeBanner: false,
            home: Home()));
  }
}

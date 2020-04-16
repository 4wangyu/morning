import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morning/screens/add_update_alarm.dart';
import 'package:provider/provider.dart';
import 'package:morning/services/alarm_provider.dart';
import 'package:morning/services/radio_player.dart';

import 'config.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String env = 'dev';
  final config = await AppConfig.forEnvironment(env);

  // pass our config to our app
  runApp(AlarmApp(config));
}

class AlarmApp extends StatefulWidget {
  final config;
  AlarmApp(this.config);

  _AlarmAppState createState() => _AlarmAppState(this.config);
}

class _AlarmAppState extends State<AlarmApp> {
  var config;

  _AlarmAppState(this.config);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: AlarmProvider()),
          ChangeNotifierProvider.value(value: RadioGaGa()),
        ],
        child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/add-update-alarm': (context) => AddUpdateAlarm(),
            },
            theme: ThemeData(
                fontFamily: 'SourceSansPro',
                primaryColor: Color(0xff1B2C57),
                accentColor: Color(0xff65D1BA)),
            debugShowCheckedModeBanner: false,
            home: Home()));
  }
}

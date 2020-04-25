import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morning/screens/alarm_screen.dart';
import 'package:morning/screens/clock_page.dart';
import 'package:morning/services/alarm_provider.dart';
import 'package:morning/services/douban_fm.dart';
import 'package:morning/theme.dart';
import 'package:morning/widgets/alarm_item.dart';
import 'package:provider/provider.dart';

import 'models/alarm_model.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  AlarmProvider alarmProvider = AlarmProvider();
  DoubanFm fm = new DoubanFm();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  // for display of add alarm button
  void _handleTabIndex() {
    setState(() {});
  }

  bool _isAlarmOneTime(AlarmModel alarm) {
    return int.parse(alarm.alarmDays) == 0;
  }

  void _getTime() {
    final DateTime now = DateTime.now();

    if (AlarmProvider.nextAlarmTime != null) {
      int diffSeconds = now.difference(AlarmProvider.nextAlarmTime).inSeconds;

      // print(AlarmProvider.nextAlarmTime);
      // print(diffSeconds);

      if (diffSeconds == 0) {
        alarmProvider.alarmOn = true;
        if (_isAlarmOneTime(alarmProvider.nextAlarm)) {
          alarmProvider.updateAlarmStatus(alarmProvider.nextAlarm.id);
        } else {
          alarmProvider.scheduleAlarm();
        }

        // if (!radio.isPlaying) {
        //   radio.play();
        // }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);
    final alarmList = alarmProvider.alarms ?? [];

    return alarmProvider.alarmOn
        ? AlarmScreen()
        : DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: primaryColor,
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: accentColor,
                  indicatorWeight: 4.0,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.access_time),
                      text: 'Clock',
                    ),
                    Tab(icon: Icon(Icons.alarm), text: 'Alarm'),
                    Tab(icon: Icon(Icons.radio), text: 'FM'),
                  ],
                ),
              ),
              body: Container(
                color: primaryColor,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    ClockPage(),
                    Container(
                      child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: ListView.builder(
                            itemCount: alarmList.length,
                            itemBuilder: (context, idx) {
                              return AlarmItem(alarmList[idx], idx);
                            },
                          )),
                    ),
                    Row(children: [
                      FlatButton(
                          onPressed: () => fm.play(),
                          child: Icon(
                            Icons.play_arrow,
                            size: 20.0,
                          )),
                      FlatButton(
                        onPressed: () => fm.stop(),
                        child: Icon(
                          Icons.pause,
                          size: 20.0,
                        ),
                      ),
                      FlatButton(
                        onPressed: () => alarmProvider.turnOffAlarm(),
                        child: Icon(
                          Icons.open_in_new,
                          size: 20.0,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              floatingActionButton: _addAlarmButton(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          );
  }

  Widget _addAlarmButton() {
    return _tabController.index == 1
        ? FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/add-update-alarm'),
            backgroundColor: accentColor,
            child: Icon(
              Icons.add,
              size: 20.0,
            ),
          )
        : null;
  }
}

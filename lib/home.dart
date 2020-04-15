import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ui_clock_and_alarm/screens/radio.dart';
import 'package:ui_clock_and_alarm/services/alarm_provider.dart';
import 'package:ui_clock_and_alarm/services/radio_player.dart';
import 'package:ui_clock_and_alarm/widgets/clock_painter.dart';
import 'package:ui_clock_and_alarm/widgets/alarm_item.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String _timeString;
  TabController _tabController;
  RadioGaGa radio = RadioGaGa();
  AlarmProvider alarmProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);

    _timeString = _formatDateTime(DateTime.now());
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

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);

    if (AlarmProvider.nextAlarm != null) {
      int diffSeconds = now.difference(AlarmProvider.nextAlarm).inSeconds;
      if (diffSeconds == 0 && !radio.isPlaying) {
        radio.play();
      }
    }

    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat().add_jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);
    // this.alarmProvider = alarmProvider;
    final alarmList = alarmProvider.alarms ?? [];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).accentColor,
            indicatorWeight: 4.0,
            tabs: [
              Tab(
                icon: Icon(Icons.access_time),
                text: 'Clock',
              ),
              Tab(icon: Icon(Icons.alarm), text: 'Alarm'),
              Tab(icon: Icon(Icons.radio), text: 'Radio'),
            ],
          ),
        ),
        body: Container(
          color: Theme.of(context).primaryColor,
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomPaint(
                        painter: ClockPainter(),
                        child: Container(
                          height: 500,
                        ),
                      ),
                    ),
                    Text(
                      _timeString.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceSansPro'),
                    )
                  ],
                ),
              ),
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
              Container(child: RadioPage()),
            ],
          ),
        ),
        floatingActionButton: _addAlarmButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _addAlarmButton() {
    return _tabController.index == 1
        ? FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/add-update-alarm'),
            backgroundColor: Color(0xff65D1BA),
            child: Icon(
              Icons.add,
              size: 20.0,
            ),
          )
        : null;
  }
}

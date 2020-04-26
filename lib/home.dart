import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morning/screens/alarm_screen.dart';
import 'package:morning/screens/clock_page.dart';
import 'package:morning/services/alarm_provider.dart';
import 'package:morning/theme.dart';
import 'package:morning/widgets/alarm_item.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
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

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);
    final alarmList = alarmProvider.alarms ?? [];

    return alarmProvider.alarmOn
        ? AlarmScreen()
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(84.0),
                  child: AppBar(
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
                      ],
                    ),
                  )),
              body: Container(
                color: primaryColor,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    ClockPage(),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: ListView.builder(
                          itemCount: alarmList.length,
                          itemBuilder: (context, idx) {
                            return AlarmItem(alarmList[idx], idx);
                          },
                        )),
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

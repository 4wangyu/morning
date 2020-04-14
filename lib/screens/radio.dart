import 'package:flutter/material.dart';
import 'package:ui_clock_and_alarm/widgets/radio_control.dart';
import 'package:ui_clock_and_alarm/widgets/vinyl.dart';

class RadioPage extends StatefulWidget {
  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> with TickerProviderStateMixin {
  AnimationController vinylController;
  Animation<double> vinylAnimation;
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

  @override
  void initState() {
    super.initState();
    vinylController = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    vinylAnimation =
        new CurvedAnimation(parent: vinylController, curve: Curves.linear);

    vinylAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        vinylController.repeat();
      } else if (status == AnimationStatus.dismissed) {
        vinylController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1B2C57),
        body: Column(
          children: <Widget>[
            new Container(
              child: Vinyl(animation: _commonTween.animate(vinylController)),
              margin: EdgeInsets.only(top: 80.0),
            ),
            RadioControls()
          ],
        ));
  }
}

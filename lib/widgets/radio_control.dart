import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_clock_and_alarm/services/radio_player.dart';

class BottomControls extends StatelessWidget {
  final RadioGaGa radio = RadioGaGa();
  final bool isPlaying = true;
  final Function pause = null;
  final Function play = null;
  final Function onPrevious = null;
  final Function onPlaying = null;
  final Function onNext = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: Material(
        shadowColor: const Color(0x44000000),
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 80),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(
                onPressed: () {
                  radio.playPrevious();
                },
                icon: new Icon(
                  Icons.skip_previous,
                  size: 32.0,
                  color: Colors.white,
                ),
              ),
              new IconButton(
                onPressed: () {
                  radio.playPause();
                  // setState(() {
                  //   isPlaying = !isPlaying;
                  //   onPlaying(isPlaying);
                  // });
                },
                padding: const EdgeInsets.all(0.0),
                icon: new Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 48.0,
                  color: Colors.white,
                ),
              ),
              new IconButton(
                onPressed: () {
                  radio.playNext();
                },
                icon: new Icon(
                  Icons.skip_next,
                  size: 32.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}

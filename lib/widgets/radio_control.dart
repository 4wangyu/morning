import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_clock_and_alarm/services/radio_player.dart';

class RadioControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioGaGa>(context);

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new IconButton(
                onPressed: () {
                  radioProvider.playPrevious();
                },
                icon: new Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                ),
                iconSize: 50),
            new IconButton(
                onPressed: () {
                  radioProvider.playPause();
                },
                // padding: const EdgeInsets.only(left: 0.0),
                icon: new Icon(
                  radioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                iconSize: 60),
            new IconButton(
                onPressed: () {
                  radioProvider.playNext();
                },
                icon: new Icon(
                  Icons.skip_next,
                  color: Colors.white,
                ),
                iconSize: 50),
          ],
        ));
  }
}

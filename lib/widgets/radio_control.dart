import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomControls extends StatelessWidget {
  var isPlaying = true;
  Function pause;
  Function play;
  Function onPrevious;
  Function onPlaying;
  Function onNext;

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
                  onPrevious();
                },
                icon: new Icon(
                  Icons.skip_previous,
                  size: 32.0,
                  color: Colors.white,
                ),
              ),
              new IconButton(
                onPressed: () {
                  if (isPlaying)
                    pause();
                  else {
                    play();
                  }
                  setState(() {
                    isPlaying = !isPlaying;
                    onPlaying(isPlaying);
                  });
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
                  onNext();
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

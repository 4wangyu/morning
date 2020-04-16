import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class Vinyl extends AnimatedWidget {
  Vinyl({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 10.0),
      height: 330.0,
      width: 330.0,
      child: new RotationTransition(
          turns: animation,
          child: new Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: Image.asset('assets/images/vinyl.jpg').image,
              ),
            ),
          )),
    );
  }
}

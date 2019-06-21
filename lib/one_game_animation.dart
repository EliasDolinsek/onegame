import 'package:flutter/material.dart';

class OneGameAnimation extends StatefulWidget {
  @override
  _OneGameAnimationState createState() => _OneGameAnimationState();
}

class _OneGameAnimationState extends State<OneGameAnimation>
    with SingleTickerProviderStateMixin {
  static const _texts = ["Picture", "Question", "Answer", "Game"];

  AnimationController animationController;
  Animation textAnimation;
  int currentTextIndex = 0;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    textAnimation = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)).animate(animationController);

    _startAnimation();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _startAnimation() async {
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (currentTextIndex + 1 != _texts.length) {
          animationController.reverse().whenComplete(() {
            _startAnimation();
            _nextText();
          });
        }
      }
    });

    animationController.forward(from: 0);
  }

  void _nextText() {
    if ((currentTextIndex + 1) == _texts.length) {
      currentTextIndex = 0;
    } else {
      currentTextIndex++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: textAnimation,
      builder: (context, child) => FadeTransition(
        opacity: textAnimation,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "ONE",
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(width: 8.0),
            Text(
              _texts.elementAt(currentTextIndex),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}

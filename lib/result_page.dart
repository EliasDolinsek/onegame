import 'package:flutter/material.dart';
import 'package:onegame/core/game.dart';
import 'package:onegame/questions_list.dart';

class ResultPage extends StatelessWidget {
  final Game game;

  ResultPage(this.game);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
        backgroundColor: Colors.white,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Column(
              children: <Widget>[
                SizedBox(height: 32.0,),
                ScoreTexts(game),
                SizedBox(
                  height: 34.0,
                ),
                QuestionsList(
                  game,
                  rightText: RightTexts.userAnswer,
                ),
              ],
            );
          } else {
            return Row(
              children: <Widget>[
                Expanded(child: Center(child: ScoreTexts(game),),),
                Expanded(child: QuestionsList(game, rightText: RightTexts.userAnswer,),)
              ],
            );
          }
        },
      ),
    );
  }
}

class ScoreTexts extends StatefulWidget {
  final Game game;

  ScoreTexts(this.game);

  @override
  _ScoreTextsState createState() => _ScoreTextsState();
}

class _ScoreTextsState extends State<ScoreTexts>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<int> scoreAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    scoreAnimation = IntTween(begin: 0, end: widget.game.correctAnswersCount)
        .chain(CurveTween(curve: Curves.linear))
        .animate(animationController);

    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: scoreAnimation,
          builder: (context, child) => Text(
                "${scoreAnimation.value}/${widget.game.questions.length}",
                style: TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -1.5),
              ),
        ),
        Text(
          widget.game.title,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: .1),
        ),
      ],
    );
  }
}

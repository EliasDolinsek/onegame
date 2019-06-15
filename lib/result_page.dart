import 'package:flutter/material.dart';
import 'package:onegame/core/game.dart';
import 'package:onegame/questions_list.dart';

class ResultPage extends StatelessWidget {
  final Game game;

  ResultPage(this.game);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 64.0, bottom: 32.0),
        child: Column(
          children: <Widget>[
            ScoreTexts(game),
            SizedBox(height: 24.0,),
            QuestionsList(
              game,
              rightText: RightTexts.userAnswer,
            ),
            SizedBox(height: 32,),
            Expanded(
              child: Align(
                child: MaterialButton(
                  child: Text("HOME", style: TextStyle(color: Theme.of(context).primaryColor),),
                  onPressed: () => Navigator.pop(context),
                ),
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
        ),
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
    scoreAnimation = IntTween(begin: 0, end: widget.game.correctAnswersCount).chain(CurveTween(curve: Curves.linear))
        .animate(animationController);

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: scoreAnimation,
          builder: (context, child) =>
              Text("${scoreAnimation.value}/${widget.game.questions.length}", style: TextStyle(fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),),
        ),
        Text(widget.game.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: .1),),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'core/game.dart';
import 'core/game_manager.dart';
import 'core/question.dart';

class GamePage extends StatefulWidget {
  final Game game;

  GamePage(this.game);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  GameManager _gameManager;
  Question _currentQuestion;

  @override
  void initState() {
    super.initState();
    _gameManager = GameManager(widget.game, Duration(seconds: 5));
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    _controller.forward();

    _loadNext();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: _currentQuestion.image.image,
                  fit: BoxFit.cover,
                  alignment: Alignment.center),
            ),
          ),
          _gameContentWidget
        ],
      ),
    );
  }

  Widget get _gameContentWidget => Padding(
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 32.0),
        child: Align(
          child: _gameControlsWidget,
          alignment: Alignment.bottomCenter,
        ),
      );

  Widget get _gameControlsWidget => FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(_controller),
        child: GameControls(
          title: _currentQuestion.title,
          onTruePressed: () => _answerQuestion(true),
          onFalsePressed: () => _answerQuestion(false),
        ),
      );

  void _answerQuestion(bool answeredWithTrue) {
    _currentQuestion.answered = true;
    _currentQuestion.answerCorrect =
        _currentQuestion.answerCorrect == answeredWithTrue ? true : false;
    setState(() {
      _loadNext();
    });
  }

  void _loadNext() {
    try {
      _currentQuestion = _gameManager.question;
    } catch (e) {
      Navigator.pop(context);
    }
  }
}

class GameControls extends StatelessWidget {
  final String title;
  final Function onTruePressed, onFalsePressed;

  const GameControls({this.title, this.onTruePressed, this.onFalsePressed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Material(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              titleWidget,
              Divider(),
              _buttonsWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget get titleWidget => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: .15),
        ),
      );

  Widget _buttonsWidget(BuildContext context) => IntrinsicHeight(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _falseButtonWidget(),
        VerticalDivider(),
        _trueButtonWidget(context),
      ],
    ),
  );

  Widget _trueButtonWidget(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTruePressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            "TRUE",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 1.25,
                color: Theme.of(context).primaryColorDark),
          ),
        ),
      );

  Widget _falseButtonWidget() => InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onFalsePressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            "FALSE",
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14, letterSpacing: 1.25),
          ),
        ),
      );
}

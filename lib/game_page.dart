import 'package:flutter/material.dart';
import 'core/game.dart';
import 'core/game_manager.dart';
import 'core/question.dart';
import 'result_page.dart';

class GamePage extends StatefulWidget {
  final Game game;

  GamePage(this.game);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool hideAnimationActive = false, showAnimationActive = false;

  final showHideAnimationDuration = Duration(milliseconds: 400);
  final shakeAnimationDuration = Duration(milliseconds: 100);

  GameManager _gameManager;
  Question _currentQuestion;

  @override
  void initState() {
    super.initState();
    _gameManager = GameManager(widget.game, Duration(seconds: 5));
    _currentQuestion = _gameManager.question;

    animationController = AnimationController(vsync: this);
    _showControlsAnimated();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
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
          child: _gameControlsWidget(),
          alignment: Alignment.bottomCenter,
        ),
      );

  Widget _gameControlsWidget() {
    final animation = controlsWidgetTween
        .chain(CurveTween(
            curve: hideAnimationActive || showAnimationActive
                ? Curves.bounceIn
                : Curves.easeInOut))
        .animate(animationController);

    return AnimatedBuilder(
      animation: animation,
      child: GameControls(
        title: _currentQuestion.title,
        onTruePressed: () => _answerQuestion(true),
        onFalsePressed: () => _answerQuestion(false),
      ),
      builder: (context, child) => Transform.translate(
            offset: Offset(0, animation.value),
            child: child,
          ),
    );
  }

  get controlsWidgetTween {
    if (showAnimationActive) {
      return Tween(begin: 200.0, end: 0.0);
    } else if (hideAnimationActive) {
      return Tween(begin: 0.0, end: 200.0);
    } else {
      return Tween(begin: 0.0, end: 10.0);
    }
  }

  void _answerQuestion(bool answer) {
    _currentQuestion.answered = true;
    _currentQuestion.answeredCorrectly =
        _currentQuestion.answerCorrect == answer ? true : false;

    if (!_currentQuestion.answeredCorrectly) {
      _endGame();
    } else {
      _loadNextQuestion();
    }
  }

  void _loadNextQuestion() {
    try {
      _currentQuestion = _gameManager.question;
      _shakeControls();
    } catch (e) {
      _endGame();
    }
  }

  void _endGame() async {
    var onAnimationComplete = (status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(widget.game),
          ),
        );
      }
    };

    _hideControlsAnimated(onAnimationComplete);
  }

  void _shakeControls() {
    setState(() {
      showAnimationActive = false;
      hideAnimationActive = false;
    });

    animationController.duration = shakeAnimationDuration;
    animationController
        .forward(from: 0)
        .whenComplete(() => animationController.reverse());
  }

  void _showControlsAnimated() {
    setState(() {
      hideAnimationActive = false;
      showAnimationActive = true;
    });

    animationController.duration = showHideAnimationDuration;
    animationController.forward(from: 0);
  }

  void _hideControlsAnimated(
      Function animationListener(AnimationStatus status)) {
    setState(() {
      showAnimationActive = false;
      hideAnimationActive = true;
    });

    animationController.duration = showHideAnimationDuration;
    animationController.addStatusListener(animationListener);
    animationController.forward(from: 0);
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                titleWidget,
                SizedBox(
                  height: 8.0,
                ),
                _buttonsWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get titleWidget => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: .15),
        ),
      );

  Widget _buttonsWidget(BuildContext context) => IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _falseButtonWidget(),
            //VerticalDivider(),
            _trueButtonWidget(context),
          ],
        ),
      );

  Widget _trueButtonWidget(BuildContext context) => IconButton(
      icon: Icon(
        Icons.check,
        color: Theme.of(context).primaryColor,
      ),
      onPressed: onTruePressed);

  Widget _falseButtonWidget() =>
      IconButton(icon: Icon(Icons.close), onPressed: onFalsePressed);
}

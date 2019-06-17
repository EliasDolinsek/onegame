import 'package:flutter/material.dart';

import 'core/game.dart';
import 'core/question.dart';

class QuestionsList extends StatefulWidget {
  static const rightTextShowNothing = 0;
  static const rightTextUserAnswers = 1;
  static const rightTextCorrectAnswers = 2;

  final Game game;
  final RightTexts rightText;

  QuestionsList(this.game, {this.rightText = RightTexts.nothing});

  @override
  QuestionsListState createState() => QuestionsListState();
}

class QuestionsListState extends State<QuestionsList> {
  bool _questionsLoaded;

  @override
  void initState() {
    super.initState();
    _questionsLoaded = widget.game.questionsLoaded;

    if (!_questionsLoaded) {
      widget.game.loadQuestions().whenComplete(() {
        setState(() {
          _questionsLoaded = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questionsLoaded && widget.game.questions.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.game.questions.length,
        itemBuilder: (context, index) => getListTitleForQuestion(
            widget.game.questions.elementAt(index), index),
      );
    } else if (_questionsLoaded && widget.game.questions.isEmpty) {
      return Center(
        child: Text("No questions available 😕"),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget getRightText(Question q) {
    if (widget.rightText == RightTexts.correctAnswer) {
      return Text(q.answerCorrect.toString());
    } else if (widget.rightText == RightTexts.userAnswer) {
      return getUserAnswerAsText(q);
    } else {
      return Text("");
    }
  }

  Widget getUserAnswerAsText(Question question) {
    if (!question.answered) {
      return Chip(
          label: Text(
        "not done",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: .1),
      ));
    } else if (question.answeredCorrectly) {
      return Chip(
        label: Text(
          "passed",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: .1,
              color: Colors.white),
        ),
        backgroundColor: Colors.green,
      );
    } else {
      return Chip(
        label: Text(
          "failed",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: .1,
              color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
    }
  }

  Widget getListTitleForQuestion(Question q, int index) => ListTile(
        leading: CircleAvatar(
          child: Text((index + 1).toString()),
          foregroundColor: Colors.black,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                q.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            getRightText(q),
          ],
        ),
      );
}

enum RightTexts { correctAnswer, userAnswer, nothing }

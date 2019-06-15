import 'package:flutter/material.dart';

import 'core/game.dart';
import 'game_page.dart';

class DetailsPage extends StatefulWidget {
  final Game game;

  DetailsPage(this.game);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  ScrollController _scrollController;
  bool _lastStatus = true, _showAnswers = false;
  Function _onShowAnswerChange = (bool showAnswers) {};

  _scrollListener() {
    if (isShrink != _lastStatus) {
      setState(() {
        _lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  Color get textColor => isShrink ? Colors.black : Colors.white;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          label: Text("START"),
          icon: Icon(Icons.arrow_forward),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => GamePage(widget.game)))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[sliverAppBar],
        body: _QuestionsList(
          widget.game,
          detailsPageState: this,
        ),
      ),
    );
  }

  Widget get sliverAppBar => SliverAppBar(
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: Colors.white,
        expandedHeight: 200,
        pinned: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ActionChip(
              label: Text(
                _showAnswers ? "HIDE ANSWERS" : "SHOW ANSWERS",
                style: TextStyle(
                    color: textColor == Colors.black
                        ? Colors.white
                        : Colors.black),
              ),
              onPressed: () => setState(() {
                    _showAnswers = !_showAnswers;
                    if (_onShowAnswerChange != null)
                      _onShowAnswerChange(_showAnswers);
                  }),
              backgroundColor: textColor,
            ),
          )
        ],
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          collapseMode: CollapseMode.parallax,
          title: Text(
            widget.game.title,
            style: TextStyle(color: textColor),
          ),
          background: Hero(
            tag: "game_image${widget.game.hashCode}",
            child: widget.game.image,
          ),
        ),
      );
}

class _QuestionsList extends StatefulWidget {
  final Game game;
  final _DetailsPageState detailsPageState;

  _QuestionsList(this.game, {this.detailsPageState});

  @override
  _QuestionsListState createState() => _QuestionsListState();
}

class _QuestionsListState extends State<_QuestionsList> {
  bool _questionsLoaded, _showAnswers = false;

  @override
  void initState() {
    super.initState();
    _questionsLoaded = widget.game.questionsLoaded;

    if (widget.detailsPageState != null) {
      widget.detailsPageState._onShowAnswerChange = (showAnswers) {
        setState(() {
          _showAnswers = showAnswers;
        });
      };
    }
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
      return ListView(
        shrinkWrap: true,
        children: widget.game.questions
            .map((q) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: q.image.image,
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
                      SizedBox(width: 8.0,),
                      Text(
                        _showAnswers ? q.answerCorrect.toString() : "",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1),
                      )
                    ],
                  ),
                ))
            .toList(),
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
}

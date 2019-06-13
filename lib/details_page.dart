import 'package:flutter/material.dart';

import 'core/game.dart';

class DetailsPage extends StatefulWidget {
  final Game game;

  DetailsPage(this.game);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  ScrollController _scrollController;

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
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
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          label: Text("START"),
          icon: Icon(Icons.arrow_forward),
          onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => <Widget>[sliverAppBar],
        body: _QuestionsList(widget.game),
      ),
    );
  }

  Widget get sliverAppBar => SliverAppBar(
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: Colors.white,
        expandedHeight: 200,
        pinned: true,
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

  _QuestionsList(this.game);

  @override
  _QuestionsListState createState() => _QuestionsListState();
}

class _QuestionsListState extends State<_QuestionsList> {
  bool _questionsLoaded, _showAnswers = false;

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
                      Text(q.title),
                      Text(_showAnswers
                          ? q.answerCorrect.toString().toUpperCase()
                          : "")
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

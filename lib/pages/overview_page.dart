import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onegame/core/game.dart';

import 'package:onegame/pages/details_page.dart';
import 'package:onegame/pages/game_editor_page.dart';
import 'package:onegame/widgets/action_image.dart';

import '../one_game_animation.dart';

class OverviewPage extends StatefulWidget {
  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  int _currentIndex = 0;
  final items = [GamesList(), OneGameAnimation()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "1game",
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GameEditorPage(Game(), false))),
        child: Icon(Icons.add),
      ),
      body: items.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Container(height: 0),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Container(height: 0))
        ],
      ),
    );
  }
}

class GamesList extends StatefulWidget {
  @override
  _GamesListState createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("categories").snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return GamesCategoryList(snapshot);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class GamesCategoryList extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

  GamesCategoryList(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) => Column(
              children: <Widget>[
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  snapshot.data.documents.elementAt(index).data["name"],
                  style: TextStyle(fontSize: 20, letterSpacing: .15),
                ),
                SizedBox(
                  height: 8.0,
                ),
                GameCategoryGamesList(
                    snapshot.data.documents.elementAt(index).documentID),
                SizedBox(
                  height: 16.0,
                )
              ],
            ),
      ),
    );
  }
}

class GameCategoryGamesList extends StatelessWidget {
  final String documentId;

  GameCategoryGamesList(this.documentId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("categories")
          .document(documentId)
          .collection("games")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data.documents.map(
              (ds) {
                var game = Game.ofDocumentSnapshot(ds, documentId);
                return Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: ActionImage(
                    actionTitle: game.title,
                    image: game.image,
                    onTap: () => _showDetailsPage(game, context),
                    heroTag: "game_image${game.hashCode}",
                  ),
                );
              },
            ).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _showDetailsPage(Game game, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsPage(game),
      ),
    );
  }
}

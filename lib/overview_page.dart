import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'core/game.dart';

class OverviewPage extends StatelessWidget {
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
      body: GamesList(),
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
      builder: (context, snapshot) => Column(
            children: snapshot.data.documents
                .map((ds) => Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: GameCard(Game.ofDocumentSnapshot(ds)),
                    ))
                .toList(),
          ),
    );
  }
}

class GameCard extends StatelessWidget {
  final Game game;

  GameCard(this.game);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            height: 200,
            width: double.infinity,
            child: game.image,
          ),
        ),
        Positioned(
          top: 155,
          left: 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  game.title,
                  style: TextStyle(color: Colors.white, fontSize: 14.0, letterSpacing: .1, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

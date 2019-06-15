import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onegame/core/question.dart';

class Game {

  String title, categoryId;
  FadeInImage image;

  List<Question> questions = [];
  DocumentSnapshot documentSnapshot;
  bool _questionsLoaded = false;

  Game({this.title, this.image, this.documentSnapshot, this.categoryId});

  factory Game.ofDocumentSnapshot(DocumentSnapshot ds, String categoryId) =>
      Game(
          title: ds.data["title"],
          image: FadeInImage.assetNetwork(
            placeholder: "assets/loading_image.png",
            image: ds.data["image"],
            fadeInDuration: Duration(seconds: 0),
            fadeInCurve: Curves.linear,
            fit: BoxFit.fitWidth,
          ),
          documentSnapshot: ds,
          categoryId: categoryId);

  Future<void> loadQuestions() async {
    Firestore.instance
        .collection("categories")
        .document(categoryId)
        .collection("games")
        .document(documentSnapshot.documentID)
        .collection("questions")
        .snapshots()
        .forEach((QuerySnapshot s) {
      s.documents.forEach(
        (DocumentSnapshot ds) {
          questions.add(Question.ofDocumentSnapshot(ds));
        },
      );
    });

    _questionsLoaded = true;
  }

  get questionsLoaded => _questionsLoaded;

  get correctAnswersCount => questions.where((q) => q.answeredCorrectly).length;
}

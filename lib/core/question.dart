import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Question {

  String title;
  Image image;
  bool answerCorrect;

  Question({this.title, this.image, this.answerCorrect});

  factory Question.ofDocumentSnapshot(DocumentSnapshot ds) => Question(
        title: ds["title"],
        image: Image.network(ds["image"]),
        answerCorrect: ds["answerCorrect"],
      );
}

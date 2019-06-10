import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  String title;
  FadeInImage image;

  Game({this.title, this.image});

  factory Game.ofDocumentSnapshot(DocumentSnapshot ds) => Game(
        title: ds.data["title"],
        image: FadeInImage.assetNetwork(
          placeholder: "assets/loading_image.png",
          image: ds.data["image"],
          fadeInDuration: Duration(seconds: 0),
          fadeInCurve: Curves.linear,
          fit: BoxFit.fitWidth,
        ),
      );
}

import 'package:flutter/material.dart';

class ActionImage extends StatelessWidget {
  
  final FadeInImage image;
  final String actionTitle, heroTag;
  final Function onTap;

  ActionImage({this.image, this.actionTitle, this.heroTag, this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 200,
              width: double.infinity,
              child: backgroundImage,
            ),
          ),
          Positioned(
            top: 140,
            left: 16,
            child: Chip(
              label: Text(
                actionTitle,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  get backgroundImage => heroTag == null || image == null ? Container(color: Colors.black,) : Hero(
    child: image,
    tag: heroTag,
  );
}

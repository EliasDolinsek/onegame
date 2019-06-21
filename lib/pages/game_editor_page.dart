import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onegame/core/game.dart';
import 'package:onegame/widgets/action_image.dart';
import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class GameEditorPage extends StatefulWidget {
  final Game game;
  final bool editMode;

  GameEditorPage(this.game, this.editMode);

  @override
  _GameEditorPageState createState() => _GameEditorPageState();
}

class _GameEditorPageState extends State<GameEditorPage> {
  TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: <Widget>[
          MaterialButton(
            child: Text(actionBarText),
            onPressed: actionBarAction,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Title"),
              onChanged: (value) => setState(() => widget.game.title = value),
            ),
            SizedBox(
              height: 16.0,
            ),
            ActionImage(
              heroTag: "",
              onTap: _selectGameImage,
              image: widget.game.image,
              actionTitle: "CHANGE GAME IMAGE",
            ),
            SizedBox(
              height: 16.0,
            ),
            SizedBox(height: 8.0,),
            Divider(),
            SizedBox(height: 8.0,),
          ],
        ),
      ),
    );
  }

  void _selectGameImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    String url = await _uploadGameImage(image);

    setState(() {
      widget.game.image = FadeInImage.assetNetwork(placeholder: "loading_image.png", image: url, fit: BoxFit.fitWidth,);
    });
  }

  Future<String> _uploadGameImage(File file) async {
    final StorageReference storageReference = FirebaseStorage.instance.ref().child(gameImageName);
    final StorageUploadTask storageUploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot  snapshot = (await storageUploadTask.onComplete);

    return (await snapshot.ref.getDownloadURL());
  }

  get gameImageName => "game_image${Uuid().v1().toString()}.jpeg";

  get title => widget.game.title == null || widget.game.title.isEmpty
      ? "New Game"
      : widget.game.title;

  get actionBarText => widget.editMode ? "DELETE" : "CREATE";

  get actionBarAction => () => print("TODO");
}

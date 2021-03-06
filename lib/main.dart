import 'package:flutter/material.dart';

import 'package:onegame/pages/loading_page.dart';
void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LoadingPage(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onegame/pages/sign_in_page.dart';

import '../one_game_animation.dart';
import 'overview_page.dart';

class LoadingPage extends StatefulWidget {

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {


  _loadNextPage() async {
    var user = await FirebaseAuth.instance.currentUser();
    if(user != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OverviewPage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          OneGameAnimation(),
          SizedBox(height: 42.0,),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}

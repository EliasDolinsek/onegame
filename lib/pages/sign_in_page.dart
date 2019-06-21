import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../one_game_animation.dart';
import 'overview_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            OneGameAnimation(),
            Column(
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    "SIGN IN WITH GOOGLE",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _signInWithGoogle,
                  color: Colors.black,
                ),
                MaterialButton(
                  child: Text("CONTINUE WITHOUT SIGN IN"),
                  onPressed: _signInAnonymously,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    final googleSignInAccount = await _googleSignIn.signIn();
    final googleSignInAuthentication = await googleSignInAccount.authentication;
    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    _firebaseAuth.signInWithCredential(credential).whenComplete(
          () => _showOverviewPage(),
        );
  }

  void _signInAnonymously() async {
    FirebaseAuth.instance
        .signInAnonymously()
        .whenComplete(() => _showOverviewPage());
  }

  void _showOverviewPage() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OverviewPage()),
      );
}

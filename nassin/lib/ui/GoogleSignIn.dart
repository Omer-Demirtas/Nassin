import 'package:flutter/material.dart';
import 'package:nassin/widgets/SignInButton.dart';

class GoogleSignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GoogleSignInPage();
  }
}

class _GoogleSignInPage extends State<GoogleSignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage("assets/logo.png")),
                SizedBox(height: 50),
                SignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
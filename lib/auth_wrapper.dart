import 'package:firebase_flutter/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import 'home.dart';
import 'muser.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SignInButton(Buttons.Facebook, onPressed: () async {
            Muser b = await AuthServices().signInWithFacebook();
            if (b != null) {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (c) => Home()));
            }
          }),
          SignInButton(Buttons.Google, onPressed: () async {
            Muser b = await AuthServices().signInWithGoogle();

            if (b != null) {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (c) => Home()));
            }
          })
        ],
      ),
    ));
  }
}

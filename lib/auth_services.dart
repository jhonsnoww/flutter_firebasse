import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/muser.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final _auth = FirebaseAuth.instance;
  Muser muser = Muser();
  Map<String, dynamic> _userData;

  String get getServiceProvider {
    User user = _auth.currentUser;

    // When not logged in
    if (user != null) {
      return user.providerData[0].providerId;
    }
    return null;
  }

  getCurrentUserData() async {
    User _user = _auth.currentUser;
    print("User $_user");

    if (_user != null) {
      String providerId = _user.providerData[0].providerId;
      print("Provider Id :: $providerId");
      if (providerId == "facebook.com") {
        AccessToken _accessToken = await FacebookAuth.instance.isLogged;
        final userData = await FacebookAuth.instance.getUserData();
        _userData = userData;

        final FacebookAuthCredential credential =
            FacebookAuthProvider.credential(
          _accessToken.token,
        );
        // Once signed in, return the UserCredential
        var result =
            await FirebaseAuth.instance.signInWithCredential(credential);

        String name = _userData["name"];
        String url = _userData["picture"]["data"]["url"];

        muser.name = name;
        muser.url = url;
        muser.uid = result.user.uid;

        return muser;
      } else
        muser.name = _user.displayName;
      muser.url = _user.photoURL;
      muser.uid = _user.uid;

      return muser;
    } else
      return null;
  }

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      muser.name = result.user.displayName;
      muser.url = result.user.photoURL;
      muser.uid = result.user.uid;

      return muser;
    } on FirebaseException catch (e) {
      print("Firebase Error");
      print(e.message);
      return muser;
    } catch (e, s) {
      print("Something Error");
      print(e);
      print(s);
      return muser;
    }
  }

  signInWithFacebook() async {
    try {
      AccessToken _accessToken = await FacebookAuth.instance.login();

      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;

      final FacebookAuthCredential credential = FacebookAuthProvider.credential(
        _accessToken.token,
      );
      // Once signed in, return the UserCredential
      var result = await FirebaseAuth.instance.signInWithCredential(credential);

      String name = _userData["name"];
      String url = _userData["picture"]["data"]["url"];

      muser.name = name;
      muser.url = url;
      muser.uid = result.user.uid;

      return muser;
    } on FacebookAuthException catch (e) {
      // if the facebook login fails

      print(e.message); // print the error message in console
      // check the error type
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          print("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          print("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          print("login failed");
          break;

          return muser;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return muser;
    } catch (e, s) {
      print(e);
      print(s);
      return muser;
    }
  }

  /// Log Out
  logOut() async {
    String sp = getServiceProvider;

    if (sp != null) if (sp == "facebook.com") {
      await FacebookAuth.instance.logOut();
    } else {
      await GoogleSignIn().disconnect();
    }

    await _auth.signOut();
  }

 
}

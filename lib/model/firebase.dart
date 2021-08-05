import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/model/userStateAuthentication.dart';
import 'package:fit_manny/screens/decision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInUser(BuildContext context)async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      if (Platform.isIOS) {
        Navigator.of(context)
            .pushReplacement(CupertinoPageRoute(
          builder: (context) => UserStateAuthentication(),
        ));
      }  if (Platform.isAndroid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UserStateAuthentication(),
        ));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> signOutUser(BuildContext context)async {
    try {
      await _auth.signOut();
    _googleSignIn.signOut();
      if (Platform.isIOS) {
        Navigator.of(context)
            .pushReplacement(CupertinoPageRoute(
          builder: (context) => Decision(),
        ));
      }  if (Platform.isAndroid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Decision(),
        ));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }
}
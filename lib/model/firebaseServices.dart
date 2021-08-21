import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/main.dart';
import 'package:fit_manny/screens/decision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseServices {

  Future<void> signOut(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut();
      if (Platform.isIOS) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => Decision(),
        ));
      }
      if (Platform.isAndroid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Decision(),
        ));
      }
    } else {
      if (Platform.isIOS) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => MyApp(),
        ));
      } else if (Platform.isAndroid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyApp(),
        ));
      }
    }
  }
}

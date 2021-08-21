import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/screens/home.dart';
import 'package:fit_manny/screens/registerFormGoogle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices{
  BuildContext context;

  FirebaseServices(this.context);

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
      try{
      await _auth.signInWithCredential(credential);
      _authenticator();
      }on FirebaseAuthException catch  (e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }
  Future<void> reAuthenticate(BuildContext context)async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try{
        FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
      }on FirebaseAuthException catch  (e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _authenticator() async {
    FirebaseFirestore _server = FirebaseFirestore.instance;
    _server
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        if (Platform.isIOS) {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => Home(),
          ));
        } else if (Platform.isAndroid) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Home(),
          ));
        }
      } else {
        if (Platform.isIOS) {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => GoogleForm(),
          ));
        } else if (Platform.isAndroid) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => GoogleForm(),
          ));
        }
      }
    });
  }
}
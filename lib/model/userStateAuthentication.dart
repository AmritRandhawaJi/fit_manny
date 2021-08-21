import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/screens/home.dart';
import 'package:fit_manny/screens/registerForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserStateAuthentication extends StatefulWidget {
  final String countryCode;
  final String number;

  UserStateAuthentication({required this.countryCode,required this.number});

  @override
  _UserStateAuthenticationState createState() =>
      _UserStateAuthenticationState();
}

class _UserStateAuthenticationState extends State<UserStateAuthentication> {
  @override
  void initState() {
    super.initState();
    _authenticator();
  }


  FirebaseFirestore _server = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Platform.isIOS
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black)),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _authenticator() async {
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
            builder: (context) => RegisterForm(number: widget.number,countryCode: widget.countryCode,),
          ));
        } else if (Platform.isAndroid) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => RegisterForm(number: widget.number,countryCode: widget.countryCode,),
          ));
        }
      }
    });
  }
}

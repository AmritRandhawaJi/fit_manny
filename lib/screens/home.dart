import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/main.dart';
import 'package:fit_manny/screens/mainScreens/profile.dart';
import 'package:fit_manny/screens/registerForm.dart';
import 'package:fit_manny/widgets/errors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!.reload();
      _validate();
    } else {
      if (Platform.isIOS) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => MyApp(),
        ));
      }
      if (Platform.isAndroid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyApp(),
        ));
      }
    }
    super.initState();
  }

  Future<dynamic> _validate() async {
    FirebaseFirestore _server = FirebaseFirestore.instance;
    await _server
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if(!documentSnapshot.get("profileComplete")){
          Error(
              context,
              "Incomplete profile",
              "Your profile is incomplete Please complete your profile",
              "Proceed")
              .show(RegisterForm());        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    if (Platform.isIOS) {
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => Profile(),
                      ));
                    }
                    if (Platform.isAndroid) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Profile(),
                      ));
                    }
                  },
                  child: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.black,
                  )),
            )
          ],
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Text(
              "Welcome",
              style: TextStyle(fontSize: 28, fontFamily: "Ubuntu"),
            ),
            Center(
              child: Container(
                  height: 400,
                  width: 400,
                  child: RiveAnimation.asset(
                    "anim/circle.riv",
                    controllers: [SimpleAnimation('Animation 1')],
                  )),
            ),
          ],
        ));
  }
}

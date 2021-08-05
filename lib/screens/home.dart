import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/model/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return AccountSetting();
  }
}

class AccountSetting extends StatefulWidget {

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Amrit Randhawa",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Ubuntu"),
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.displayName.toString(),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Ubuntu"),
                )
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            CupertinoButton(
              color: Colors.black,
              onPressed: () async {
                FirebaseServices service = new FirebaseServices();
                service.signOutUser(context);
              },
              child: Text("Sign out"),
            )
          ],
        ),
      ),
    );
  }
}

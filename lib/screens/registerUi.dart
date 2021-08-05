import 'dart:io';
import 'package:fit_manny/assets/my_flutter_app_icons.dart';
import 'package:fit_manny/model/firebase.dart';
import 'package:fit_manny/screens/phoneOTP.dart';
import 'package:fit_manny/widgets/internetAlert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterUi extends StatefulWidget {
  @override
  _RegisterUiState createState() => _RegisterUiState();
}

class _RegisterUiState extends State<RegisterUi> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset("images/register.png"),
            ),
            Text(
              "Let's create account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            CupertinoButton(
              color: Colors.black,
              onPressed: () async {
                if (Platform.isIOS) {
                  Navigator.of(context).pushReplacement(CupertinoPageRoute(
                    builder: (context) => MobileAuthentication(),
                  ));
                } else if (Platform.isAndroid) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MobileAuthentication(),
                  ));
                } else {
                  InternetError(context).show();
                }
              },
              child: Text(
                "Continue with phone number",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                    child: Divider(
                      color: Colors.black,
                      height: 50,
                    )),
              ),
              Text("OR"),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 50,
                    )),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  color: Colors.black,
                  onPressed: () async {
                FirebaseServices service = new FirebaseServices();
                service.signInUser(context);
                  },
                  child: Icon(
                    MyFlutterApp.google,
                    color: Colors.white,
                  ),
                ),
                CupertinoButton(
                  color: Colors.black,
                  onPressed: () {},
                  child: Icon(
                    MyFlutterApp.facebook,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
           ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:fit_manny/screens/phoneOTP.dart';
import 'package:fit_manny/widgets/internetAlert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Welcome",
              style: TextStyle(fontFamily: "Ubuntu",color: Colors.black),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset("images/register.png"),
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
            Flexible(
              child: Text(
                "#Fitness is important for everyone.",
                style: TextStyle(fontSize: 20,fontFamily: "Ubuntu"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

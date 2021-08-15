import 'dart:io';
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
              "#fitness is important for everyone",
              style: TextStyle(fontSize: 20,fontFamily: "Ubuntu"),
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

            CupertinoButton(

              color: Colors.black,
              onPressed: () async {
            FirebaseServices service = new FirebaseServices();
            service.signInUser(context);
              },
              child: Text("Continue with google"),
            ),

            // Must be implemented for apple sign in
            Container(
              child: Platform.isIOS ? CupertinoButton(
                  color: Colors.black,
                  child: Text("Continue with apple"), onPressed: (){
              }): null,
            )
           ],
        ),
      ),
    );
  }
}

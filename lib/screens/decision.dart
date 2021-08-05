import 'dart:io';
import 'package:fit_manny/screens/registerUi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Decision extends StatefulWidget {
  @override
  _DecisionState createState() => _DecisionState();
}

class _DecisionState extends State<Decision> {
  bool result = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/welcome.jpg"), fit: BoxFit.cover),
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  "Welcome",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: "Arvo",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  "Create your profile to achieve your goals",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Ubuntu",
                  ),
                ),
              ),
            ],
          ),

          Column(
            children: [
              CupertinoButton(
                onPressed: () {
                  if (Platform.isIOS) {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                      builder: (context) => RegisterUi(),
                    ));
                  } else if (Platform.isAndroid) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => RegisterUi(),
                    ));
                  }
                },
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.white,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "By clicking continue you are accepting terms and conditions for read more about visit on website",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: "Ubuntu",
              ),
            ),
          ),
        ]),
      )),
    );
  }
}

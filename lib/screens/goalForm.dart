import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/widgets/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class GoalsForm extends StatefulWidget {
  @override
  _GoalsFormState createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {
  double _value = 1;
  String _valueDisplay = "Beginner";

  bool _goalState = false;
  bool _goalState2 = false;

  var _goalValue ;

  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          elevation: 0,
          backgroundColor: Colors.teal[100],
        ),
        backgroundColor: Colors.teal[100],
        body:
            Stack(
              children: [

                Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Text(
                    "Create your goals",
                    style: TextStyle(fontFamily: "Ubuntu", fontSize: 24),
                  ),
                  Image.asset(
                    "images/goal.png",
                    width: MediaQuery.of(context).size.width/1.2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: _goalState ? Colors.teal : Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                topLeft: Radius.circular(25))),
                        child: TextButton(
                          onPressed: () {
                            setState(() {

                              _goalState = true;
                              _goalState2 = false;
                              _goalValue = "Weight_Gain";
                            });
                          },
                          child: Text(" Weight Gain ",style: TextStyle(color: _goalState ? Colors.white : Colors.blue),),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: _goalState2 ? Colors.teal : Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _goalValue = "Weight_Loss";
                              _goalState2 = true;
                              _goalState = false;
                            });
                          },
                          child: Text(" Weight loss ",style: TextStyle(color: _goalState2 ? Colors.white : Colors.blue),),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Tell us about your experience in fitness?",
                    style: TextStyle(fontFamily: "Ubuntu", fontSize: 14),
                  ),
                  Text(
                    "I am  $_valueDisplay",
                    style: TextStyle(fontFamily: "Ubuntu", fontSize: 20),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(

                      showValueIndicator: ShowValueIndicator.always,
                      activeTrackColor: Colors.pink,
                      inactiveTrackColor: Colors.black45,
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 8.0,

                      thumbColor: Colors.pink[100],
                      valueIndicatorColor: Colors.teal,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 20.0),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 50.0),
                    ),
                    child: Slider(
                      value: _value,
                      min: 1,
                      max: 3,
                      divisions: 2,
                      label: _valueDisplay,
                      onChanged: (double value) {
                        setState(() {
                          _value = value;
                          if (value.toInt() == 1) {
                            _valueDisplay = "Beginner";
                          }

                          if (value.toInt() == 2) {
                            _valueDisplay = "Intermediate";
                          }
                          if (value.toInt() == 3) {
                            _valueDisplay = "Professional";
                          }
                        });
                      },
                    ),
                  ),
                  CupertinoButton(
                      color: Colors.white,
                      child: Text("Go",style: TextStyle(color: Colors.black),), onPressed: (){
                    if(_goalValue != null){

                      _createDatabase();
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Select your goal")));
                    }

                  })
                ]),

              Container(

                child:  _loading ? Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(

                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)

                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Indicator(),

                          Text("Creating profile")
                        ],
                      ),
                    ),
                  ) : null,
              )
              ],
            ));
  }
  Future<void> _createDatabase() async {
    setState(() {
      _loading = true;
    });
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({

      "FITNESSACTIVE" : _valueDisplay,
      "GOAL" : _goalValue,
      "PROFILECOMPLETE": true
    }, SetOptions(merge: true)).then((value) => {
      if (Platform.isIOS)
        {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => Home(),
          ))
        }
      else if (Platform.isAndroid)
        {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Home(),
          ))
        }
    });
  }

}

import 'package:firebase_core/firebase_core.dart';
import 'package:fit_manny/model/mover.dart';
import 'package:fit_manny/widgets/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((_firebaseUser) {
      if(_firebaseUser != null) {
        if (Platform.isIOS) {
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => Home(),));
        }
        else if (Platform.isAndroid) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Home(),));
        }
      }
      else{
        _checkUser();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
              child: Indicator()),
        ),
      ),
    );
  }

  void _checkUser() async{

      if (Platform.isIOS) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => Mover(),
        ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Mover(),
            ));
      }
    }
  }


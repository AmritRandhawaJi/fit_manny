import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_manny/screens/decision.dart';
import 'package:fit_manny/screens/gettingStarted.dart';
import 'package:fit_manny/widgets/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => Future.delayed(Duration(seconds: 2),(){
      _checkUser();
    }));
    return Scaffold(
      body: Center(child: Indicator.show(context)),
    ); // widget tree
  }

  void _checkUser() async {

    if (FirebaseAuth.instance.currentUser == null) {

      final value = await SharedPreferences.getInstance();
      if (value.getInt("userState") != 1) {
        if (Platform.isIOS) {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => GettingStartedScreen(),
          ));
        } if (Platform.isAndroid) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => GettingStartedScreen(),
          ));
        }
      } else {
        if (Platform.isIOS) {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => Decision(),
          ));
        } if (Platform.isAndroid) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Decision(),
          ));
        }
      }

    } else {
      if (Platform.isIOS) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => Home(),
        ));
      }
      if (Platform.isAndroid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Home(),
        ));
      }
    }
}
}

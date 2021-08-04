import 'dart:async';
import 'dart:io';
import 'package:fit_manny/screens/decision.dart';
import 'package:fit_manny/screens/gettingStarted.dart';
import 'package:fit_manny/widgets/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mover extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 2), (timer) async {
     await _authenticator(context);
      timer.cancel();
    });
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Indicator()
        ),
      ),
    );

  }
  Future<void> _authenticator(BuildContext context) async {
    final value =  await SharedPreferences.getInstance();
    if(value.getInt("userState") != 1) {
      if (Platform.isIOS) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => GettingStartedScreen(),));
      }
      else if (Platform.isAndroid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GettingStartedScreen(),));
      }
    }
    else{
      if (Platform.isIOS) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => Decision(),));
      }
      else if (Platform.isAndroid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Decision(),));
      }
    }
}
}

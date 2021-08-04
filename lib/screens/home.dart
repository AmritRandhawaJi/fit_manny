import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fit_manny/screens/decision.dart';
import 'decision.dart';

class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(tabBar: CupertinoTabBar(items: [
BottomNavigationBarItem(icon: Icon(Icons.home),backgroundColor: Colors.black,label: "Home"),
BottomNavigationBarItem(icon: Icon(Icons.apps),backgroundColor: Colors.black,label: "Fitness"),
BottomNavigationBarItem(icon: Icon(Icons.album_rounded),backgroundColor: Colors.black,label: "Trainer"),
BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),backgroundColor: Colors.black,label: "Account"),
    ],), tabBuilder: (context, index) => AccountSetting(),);
  }
}

class AccountSetting extends StatefulWidget {
  const AccountSetting({Key? key}) : super(key: key);

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Text("Amrit Randhawa",style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Ubuntu"),)
            ],
          ),
            SizedBox(height: 30.0,),
            CupertinoButton(color: Colors.black,onPressed: ()async {

              await FirebaseAuth.instance.signOut();
              if (Platform.isIOS) {
                Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => Decision(),));
              }
              else if (Platform.isAndroid) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Decision(),));
              }
            },child: Text("Sign out"),)
          ],
        ),
      ),
    );
  }
}

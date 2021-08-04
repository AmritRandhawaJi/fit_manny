import 'dart:io';
import 'package:fit_manny/assets/my_flutter_app_icons.dart';
import 'package:fit_manny/model/networkState.dart';
import 'package:fit_manny/screens/phoneOTP.dart';
import 'package:fit_manny/screens/registerUi.dart';
import 'package:fit_manny/widgets/internetAlert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'emailLoginUi.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:     Center(
            child: Text(
              "Welcome",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Ubuntu"),
            )),
        backgroundColor: Colors.black,
        toolbarHeight: MediaQuery.of(context).size.height / 3.5,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only( bottomLeft: Radius.circular(100))
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CupertinoButton(
              onPressed: () async {
                await NetworkState.state();
                if (NetworkState.status()) {
                  if (Platform.isIOS) {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                      builder: (context) => MobileAuthentication(),
                    ));
                  } else if (Platform.isAndroid) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MobileAuthentication(),
                    ));
                  }
                } else {
                  InternetError(context).show();
                }
              },
              child: Text(
                "Login with phone number",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black,
            ),
            Row(children: <Widget>[
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Divider(
                      color: Colors.black,
                      height: 50,
                    )),
              ),
              Text("OR"),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                  onPressed: () {

                  },
                  child: Icon(
                    MyFlutterApp.google,
                    color: Colors.white,
                  ),
                  color: Colors.blue,
                ),
                CupertinoButton(
                  onPressed: () {

                  },
                  child: Icon(
                    MyFlutterApp.facebook,
                    color: Colors.white,
                  ),
                  color: Colors.blue
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text("Don't have an account?",
                      style: TextStyle(color: Colors.black,fontFamily: "Ubuntu")),
                ),
                TextButton(
                    onPressed: () {
                      if (Platform.isIOS) {
                        Navigator.of(context)
                            .pushReplacement(CupertinoPageRoute(
                          builder: (context) => RegisterUi(),
                        ));
                      } else if (Platform.isAndroid) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => RegisterUi(),
                        ));
                      }
                    },
                    child: Text("Register"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

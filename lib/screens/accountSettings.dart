import 'dart:io';

import 'package:fit_manny/model/deleteRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [

                layout()
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget layout() {
    return Padding(
      padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: () {
                if (Platform.isIOS) {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) =>
                          DeleteAccountRequest(
                          )));
                }
                      if (Platform.isAndroid){
                    Navigator
                        .of(context)
                        .push(MaterialPageRoute(
                        builder: (context) =>
                           DeleteAccountRequest(
                            )));
                    }
                    },
                  child: Text(
                    "Delete account", style: TextStyle(color: Colors.black),)),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                color: Colors.black54,
                height: 10,
              ))
        ],
      ),
    );
  }
}

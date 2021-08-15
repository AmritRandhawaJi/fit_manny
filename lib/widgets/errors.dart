
import 'dart:io';

import 'package:fit_manny/screens/home.dart';
import 'package:fit_manny/screens/registerForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Error{
  BuildContext context;
  String title;
  String content;
  String errorRight;


  Error(this.context, this.title,this.content, this.errorRight);

  void show(){
    if(Platform.isIOS){
      showCupertinoDialog(context: context, builder: (context) => alert(),barrierDismissible: false);
    }if(Platform.isAndroid){
      showDialog(context: context, builder: (context) => alert(),barrierDismissible: false);
    }
  }
  Widget alert(){
    return Platform.isIOS ? CupertinoAlertDialog(
      content: Text(content),
      title: Text(title),
      actions: [
        TextButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterForm(),));
        }, child: Text(errorRight)),
      ],
    ):AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterForm(),));
        }, child: Text(errorRight)),
      ],
    );
  }


}
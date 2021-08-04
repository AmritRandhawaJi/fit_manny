
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InternetError{
 BuildContext context;
 InternetError(this.context);

 void show(){
  if(Platform.isIOS){
    showCupertinoDialog(context: context, builder: (context) => alert(),barrierDismissible: true);
  }if(Platform.isAndroid){
    showDialog(context: context, builder: (context) => alert(),barrierDismissible: false);
  }
}
 Widget alert(){
  return Platform.isIOS ? CupertinoAlertDialog(
    title: Text("No connectivity"),
    content: Text("You are not connected with internet"),
    actions: [
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text("Dismiss"))
    ],
  ): AlertDialog(
    title: Text("No connectivity"),
    content: Text("Please check your internet connection"),
    actions: [
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text("Ok"))
    ],
  );
}


}
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/model/firebase.dart';
import 'package:fit_manny/screens/mainScreens/profile.dart';
import 'package:fit_manny/widgets/errors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore server = FirebaseFirestore.instance;

  Future<dynamic> _validate() async {
    await server
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get("profileComplete") == false) {
          Error(context, "Profile incomplete",
                  "Please complete your profile to continue", "Proceed")
              .show();
        }
      } else {
        FirebaseServices().signOutUser(context);
      }
    });
  }

  @override
  void initState() {
    _validate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(onTap: (){
                if (Platform.isIOS) {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Profile(),));
                }
                 if (Platform.isAndroid) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile(),));
                }              },child: Icon(Icons.account_circle_outlined,color: Colors.black,)),
            )
          ],
            elevation: 0,
            backgroundColor: Colors.white,
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.drag_handle,color: Colors.black,),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            })),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SlidingUpPanel(
              panelBuilder: (sc) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.email),
                    Icon(Icons.email),
                    Icon(Icons.email),
                    Icon(Icons.email),
                  ],
                );
              },
          body: Column(
            children: [
              
            ],
          )
        ));
  }
}

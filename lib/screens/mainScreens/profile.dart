import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/model/firebaseServices.dart';
import 'package:fit_manny/model/profileEdit.dart';
import 'package:fit_manny/screens/accountSettings.dart';
import 'package:fit_manny/widgets/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {


  User? _auth = FirebaseAuth.instance.currentUser;
  bool _loading = true;
  String _name = "";
  String _email = "";
  String _photoURL = "";
  String _age = "";

  Future<void> _display() async {
    FirebaseFirestore _server = FirebaseFirestore.instance;
    await _server
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _name = documentSnapshot.get("name");
        _age = documentSnapshot.get("age");
        _email = documentSnapshot.get("email");
        _photoURL = documentSnapshot.get("photoURL");
      }
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    _display();
    super.initState();
  }
  FutureOr onGoBack() {
    setState(() {
      _display();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated"),));
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return _loading
                ? Shimmer.fromColors(
              highlightColor: Colors.black,
              baseColor: Colors.grey.shade100,
              child: Center(child: Indicator.show(context)))
                : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Center(
                          child: CircleAvatar(
                            child: _photoURL.isEmpty
                                ? Image.asset("images/profile.png")
                                : null,
                            backgroundImage: _photoURL.isEmpty
                                ? null
                                : NetworkImage(_photoURL),
                            backgroundColor: Colors.grey.shade100,
                            maxRadius: MediaQuery.of(context).size.width / 5,
                          ),
                        ),

                        Center(child: Text(_name,style: TextStyle(fontSize: 18,color: Colors.black87,fontFamily: "Ubuntu"),)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text("Age",style: TextStyle(),)),
                            SizedBox(
                              width: 5,
                            ),
                            Center(child: Text(_age,style: TextStyle(fontSize: 18,color: Colors.black87,fontFamily: "Ubuntu"),)),

                          ],
                        ),
                        Center(
                          child: TextButton(
                              onPressed: () async {
                                if (Platform.isIOS) {
                                 Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => ProfileEdit(),
                                  )
                                 ).then((value) => onGoBack());

                                } if (Platform.isAndroid) {
                                final result = await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProfileEdit(),
                                  )
                                  ).then((value) => onGoBack());
                                }
                              },
                              child: Text("Edit profile")),
                        ),
                        _layout("Email", _email),
                        _layout("Number", _auth!.phoneNumber.toString()),
                        GestureDetector(
                          onTap: () {
                            if (Platform.isIOS) {
                              Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => AccountSettings(),
                              ));
                            }
                            if (Platform.isAndroid) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AccountSettings(),
                              ));
                            }
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Privacy & settings"),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: CupertinoButton(
                              color: Colors.blue,
                              child: Text("Logout"),
                              onPressed: () {
                                FirebaseServices services = new FirebaseServices();
                                services.signOut(context);
                              }),
                        ),
                      ],
                    );
          },
        ),
      ),
    );
  }

  Widget _layout(String title, String data) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.blue),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                data,
                style: TextStyle(fontFamily: "Ubuntu", fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

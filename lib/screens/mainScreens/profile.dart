import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/model/firebase.dart';
import 'package:fit_manny/model/migration.dart';
import 'package:fit_manny/model/profileEdit.dart';
import 'package:fit_manny/screens/accountSettings.dart';
import 'package:fit_manny/screens/decision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  FirebaseFirestore server = FirebaseFirestore.instance;
  bool loading = true;
  String name = "";
  String country = "";
  bool verification = false;
  String email = "";
  String phone = "";
  String photoURL = "";

  Future<dynamic> _display() async {
    await server
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        name = documentSnapshot.get("name");
        country = documentSnapshot.get("countryCode");
        phone = documentSnapshot.get("phone");
        email = documentSnapshot.get("email");
        verification = documentSnapshot.get("verificationRequired");
        photoURL = documentSnapshot.get("photoURL");
        loading = false;
      });
    });
  }

  @override
  void initState() {
    _display();
    super.initState();
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
            return loading
                ? Shimmer.fromColors(
                    child:
                        ProfileView(name, email, photoURL, phone, verification,country),
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade50)
                : ProfileView(name, email, photoURL, phone, verification,country);
          },
        ),
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  final String name;
  final String email;
  final String country;
  final String photoURL;
  final String number;
  final bool verificationRequired;

  ProfileView(this.name, this.email, this.photoURL, this.number,
      this.verificationRequired,this.country);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: Text(
            "Profile",
            style: TextStyle(
                fontSize: 24, color: Colors.black, fontFamily: "Ubuntu"),
          ),
        ),
        Center(
          child: CircleAvatar(
            child: widget.photoURL.isEmpty
                ? Image.asset("images/profile.png")
                : null,
            backgroundImage:
                widget.photoURL.isEmpty ? null : NetworkImage(widget.photoURL),
            backgroundColor: Colors.grey.shade100,
            maxRadius: MediaQuery.of(context).size.width / 5,
          ),
        ),
        Center(
          child: TextButton(
              onPressed: () {
                if (Platform.isIOS) {
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => ProfileEdit(),
                  ));
                } else if (Platform.isAndroid) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileEdit(),
                  ));
                }
              },
              child: Text("Edit profile")),
        ),
        Center(
          child: Container(
              child: widget.verificationRequired
                  ? TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          TextButton(
                            child: Text("Verify Number"),
                            onPressed: () {
                              if (Platform.isIOS) {
                                Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => Migration(widget.number,widget.name,widget.country),
                                ));
                              }
                              if (Platform.isAndroid) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Migration(widget.number,widget.name,widget.country),
                                ));
                              }
                            },
                          )
                        ],
                      ))
                  : Column(
                      children: [
                        Text(widget.number),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Verified",style: TextStyle(color: Colors.green),)
                            ,Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          ],
                        )
                      ],
                    )),
        ),
        _layout("Name", widget.name, widget.verificationRequired),
        _layout("Email", widget.email, widget.verificationRequired),
        _layout("Number", widget.number, widget.verificationRequired),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if(FirebaseAuth.instance.currentUser !=null){
                  FirebaseAuth.instance.signOut();
                  if (Platform.isIOS)
                  {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                      builder: (context) => Decision(),
                    ));
                  }
                  else if (Platform.isAndroid)
                  {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Decision(),
                    ));
                  }
                }
              }),
        ),
      ],
    );
  }

  Widget _layout(String title, String data, bool verification) {
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

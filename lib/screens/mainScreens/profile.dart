import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/model/firebase.dart';
import 'package:fit_manny/model/profileEdit.dart';
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
          leading: GestureDetector(onTap: (){
            Navigator.pop(context);
          },child: Icon(Icons.arrow_back_ios, color: Colors.black,)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return loading
                ? Shimmer.fromColors(
                    child:
                        ProfileView(name, email, photoURL, phone, verification),
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade50)
                : ProfileView(name, email, photoURL, phone, verification);
          },
        ),
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  final String name;
  final String email;
  final String photoURL;
  final String number;
  final bool verificationRequired;

  ProfileView(this.name, this.email, this.photoURL, this.number,
      this.verificationRequired);

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
            style: TextStyle(fontSize: 24,color: Colors.black, fontFamily: "Ubuntu"),
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
                if (Platform.isIOS)
                {
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => ProfileEdit(),
                  ));
                }
                else if (Platform.isAndroid)
                {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileEdit(),
                  ));
                }
              },
              child: Text("Edit profile")),
        ),
        Center(
          child: Container(
              child: widget.verificationRequired ? TextButton(onPressed: (){

              }, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning,color: Colors.red,),SizedBox(
                    width: 5,
                  ),
                  Text("Verify Number"),
                ],
              )): null
          ),
        ),
        _layout("Name", widget.name,widget.verificationRequired),
        _layout("Email", widget.email,widget.verificationRequired),
        _layout("Number", widget.number,widget.verificationRequired),

        Center(
          child: CupertinoButton(
              color: Colors.blue,
              child: Text("Logout"),
              onPressed: () {
                FirebaseServices service = new FirebaseServices();
                service.signOutUser(context);
              }),
        ),
      ],
    );
  }
  Widget _layout(String title,String data,bool verification){

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: TextStyle(color: Colors.blue),),
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

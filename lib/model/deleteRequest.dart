import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/model/firebase.dart';
import 'package:fit_manny/widgets/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteAccountRequest extends StatefulWidget {
  @override
  _DeleteAccountRequestState createState() => _DeleteAccountRequestState();
}

class _DeleteAccountRequestState extends State<DeleteAccountRequest> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              "Account delete request",
              style: TextStyle(fontFamily: "Ubuntu", fontSize: 18),
            ),
          ),
          Text(
            "You are leaving us.",
            style: TextStyle(
                fontFamily: "Ubuntu", fontSize: 14, color: Colors.black45),
          ),
          Image.asset("images/delete.png"),
          CupertinoButton(
              color: Colors.black,
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                setState(() {
                  _loading = true;
                  reAuthUser();

                });
              }),
          Container(
            child: _loading ? Indicator.show(context) : null,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 15, left: 15),
            child: Text(
              "By clicking delete button, We will erase all of your data and purchases from our database.",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black45, fontFamily: "Ubuntu"),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _deleteUser() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      print(e.toString());
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _deleteDataOnDatabase() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    _deleteUser();
  }

  void reAuthUser() async {
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      FirebaseServices services = new FirebaseServices(context);
      await services.reAuthenticate(context);
      _deleteDataOnDatabase();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Feature coming soon")));
    }
  }
}

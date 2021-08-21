import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/model/migration.dart';
import 'package:fit_manny/widgets/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  String _phone = "";
  String _email = "";
  String _name = "";
  String _country = "";
  bool _loading = true;
  FirebaseFirestore _server = FirebaseFirestore.instance;

  final GlobalKey<FormState> phoneAuthKey = GlobalKey<FormState>();

  final TextEditingController _numberField = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();

  Future<dynamic> _data() async {
    await _server
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        _nameController..text = documentSnapshot.get("name").toString();
        _phone = documentSnapshot.get("phone").toString();
        _email = documentSnapshot.get("email").toString();
        _name = documentSnapshot.get("name").toString();
        _country = documentSnapshot.get("countryCode").toString();
        _numberField..text = documentSnapshot.get("phone").toString();
        _emailController..text = documentSnapshot.get("email").toString();
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    _data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: _loading
              ? Center(child: Indicator.show(context))
              : Center(
                child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "images/profile.png",
                            width: 120,
                            height: 120,
                          ),
                          TextButton(onPressed: (){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Coming soon"),
                            ));
                          }, child: Text("Change photo")),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              child: Form(
                                key: _nameKey,
                                child: TextFormField(

                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter your name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintStyle: TextStyle(color: Colors.black),
                                      labelText: "What's your name?",
                                      labelStyle: TextStyle(color: Colors.black)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              child: Form(
                                key: phoneAuthKey,
                                child: TextFormField(

                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Phone number required.";
                                    } else if (value.length < 10) {
                                      return "Enter 10 digits.";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _numberField,
                                  maxLength: 10,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  keyboardType: TextInputType.number,
                                  autofillHints: [AutofillHints.telephoneNumber],
                                  decoration: InputDecoration(
                                      prefixIcon: CountryCodePicker(
                                        initialSelection: _country,
                                        onChanged: (value) {
                                          _country = value.toString();
                                        },
                                        showOnlyCountryWhenClosed: false,
                                        alignLeft: false,
                                      ),
                                      border: OutlineInputBorder(),
                                      hintText: "Number",
                                      hintStyle: TextStyle(color: Colors.black),
                                      labelStyle: TextStyle(color: Colors.black)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                                child: Form(
                              key: _emailKey,
                              child: TextFormField(

                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter your email";
                                  } else if (!EmailValidator.validate(
                                      _emailController.value.text)) {
                                    return "Email invalid";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: _emailController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintStyle: TextStyle(color: Colors.black),
                                    labelText: "What's your email?",
                                    labelStyle: TextStyle(color: Colors.black)),
                              ),
                            )),
                          ),

                          CupertinoButton(
                              color: Colors.black,
                              child: Text(
                                "Update profile",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (_nameKey.currentState!.validate() &
                                _emailKey.currentState!.validate() &
                                _nameKey.currentState!.validate()) {
                                  updateData();
                                }

                              }),
                        ],
                      )
                    ],
                  ),
              )),
    );
  }

  updateData() async {
    if (_needUpdateEmail()) {
      await _changeEmail();
    } else if (_needUpdatePhone()) {
      _migration();
    } else if (_needUpdateName()) {
      _changeName();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Already updated"),
      ));
    }
  }

  bool _needUpdateEmail() {
    if (_emailController.value.text == _email) {
      return false;
    }
    return true;
  }

  bool _needUpdateName() {
    if (_nameController.value.text == _name) {
      return false;
    }
    return true;
  }

  bool _needUpdatePhone() {
    if (_numberField.value.text == _phone) {
      return false;
    }
    return true;
  }

  Future<void> _changeEmail() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "email": _emailController.value.text,
    }, SetOptions(merge: true)).then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Email updated"),
              )),
              if (_needUpdatePhone()) {_migration()}
            });
  }

  Future<void> _changeName() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "name": _nameController.value.text,
    }, SetOptions(merge: true)).then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Name updated"),
              )),
              if (_needUpdatePhone()) {_migration()}
            });
  }

  _migration() {
    if (Platform.isIOS) {
      Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (context) => Migration(
            _numberField.value.text, _nameController.value.text, _country),
      ));
    }
    if (Platform.isAndroid) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Migration(
            _numberField.value.text, _nameController.value.text, _country),
      ));
    }
  }
}

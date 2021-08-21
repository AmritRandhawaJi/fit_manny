import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/screens/goalForm.dart';
import 'package:fit_manny/widgets/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoogleForm extends StatefulWidget {
  const GoogleForm({Key? key}) : super(key: key);

  @override
  _GoogleFormState createState() => _GoogleFormState();
}

class _GoogleFormState extends State<GoogleForm> {
  User _user = FirebaseAuth.instance.currentUser!;

  String countryCode = "+91";
  TextEditingController _numberField = TextEditingController();
  GlobalKey<FormState> phoneAuthKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  GlobalKey<FormState> _emailKey = GlobalKey<FormState>();

  double _age = 18;
  String _ageDisplay = "18";

  bool loading = false;
  var _gender = "Male";

  @override
  void dispose() {
    FirebaseFirestore.instance.terminate();
    _nameController.dispose();
    _emailController.dispose();
    _numberField.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _registerUser();
    super.initState();
  }

  Future<void> _registerUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"account": true, "profileComplete": false},
        SetOptions(merge: true)).then((value) => {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Almost Done!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text(
                    "Create your profile",
                    style: TextStyle(
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
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
                  Container(
                      child: !_user.emailVerified
                          ? Padding(
                        padding:
                        const EdgeInsets.only(left: 40, right: 40),
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
                                labelStyle:
                                TextStyle(color: Colors.black)),
                          ),
                        ),
                      ):
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 1.2,
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
                            autofillHints: [
                              AutofillHints.telephoneNumber
                            ],
                            decoration: InputDecoration(
                                prefixIcon: CountryCodePicker(
                                  onChanged: (value) {
                                    countryCode = value.toString();
                                  },
                                  initialSelection: 'IN',
                                  favorite: ['+91', 'IN'],
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                ),
                                border: OutlineInputBorder(),
                                hintText: "Number",
                                hintStyle: TextStyle(color: Colors.black),
                                labelStyle:
                                TextStyle(color: Colors.black)),
                          ),
                        ),
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "My age is",
                        style: TextStyle(fontSize: 16, fontFamily: "Ubuntu"),
                      ),
                      Text(
                        " $_ageDisplay",
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                      ),
                    ],
                  ),
                  SliderTheme(
                      child: Slider(
                        value: _age,
                        min: 18,
                        max: 70,
                        label: _age.round().toString(),
                        activeColor: Colors.pink[100],
                        inactiveColor: Colors.black54,
                        onChanged: (double value) {
                          setState(() {
                            _age = value;
                            _ageDisplay = value.round().toString();
                          });
                        },
                      ),
                      data: SliderTheme.of(context).copyWith(
                        showValueIndicator: ShowValueIndicator.always,
                        activeTrackColor: Colors.pink,
                        inactiveTrackColor: Colors.black45,
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 8.0,
                        thumbColor: Colors.pink[100],
                        valueIndicatorColor: Colors.teal,
                        thumbShape:
                        RoundSliderThumbShape(enabledThumbRadius: 15.0),
                        overlayShape:
                        RoundSliderOverlayShape(overlayRadius: 30.0),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.male,
                            color: Colors.blue,
                          ),
                          Text(
                            "Male",
                            style:
                            TextStyle(fontFamily: "Ubuntu", fontSize: 18),
                          ),
                          Radio(
                            value: "Male",
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.female,
                            color: Colors.pink,
                          ),
                          Text(
                            "Female",
                            style:
                            TextStyle(fontFamily: "Ubuntu", fontSize: 18),
                          ),
                          Radio(
                            value: "Female",
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  CupertinoButton(
                    onPressed: () {
                      if (_nameKey.currentState!.validate()) {
                        if (_emailKey.currentState != null) {
                          if (_emailKey.currentState!.validate()) {
                            _createDatabase(false);
                          }
                        } else if (phoneAuthKey.currentState != null) {
                          if (phoneAuthKey.currentState!.validate()) {
                            _createDatabase(true);
                          }
                        }
                      }
                    },
                    child: Text(
                      "Create",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                  ),
                  Container(
                    child: loading ? Indicator.show(context) : null,
                  ),
                ])));
  }

  Future<void> _createDatabase(bool verificationRequired) async {
    setState(() {
      loading = true;
    });
    FirebaseFirestore.instance.collection("users").doc(_user.uid).set({
      "name": _nameController.value.text,
      "email": _user.email,
      "age": _age.round().toString(),
      "phone": _numberField.value.text,
      "countryCode" : _emailController.value.text,
      "gender": _gender.toUpperCase(),
      "registration": DateTime.now().toString(),
      "photoURL": "",
      "verificationRequired": verificationRequired
    }, SetOptions(merge: true)).then((value) => {
      if (Platform.isIOS)
        {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => GoalsForm(),
          ))
        }
      else if (Platform.isAndroid)
        {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => GoalsForm(),
          ))
        }
    });
  }
}

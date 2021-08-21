
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Migration extends StatefulWidget {

  final String phoneNumber;
  final String countryCode;
  final String name;

  Migration(this.phoneNumber,this.name,this.countryCode);

  @override
  _MigrationState createState() => _MigrationState();
}

class _MigrationState extends State<Migration> {
  late String _verificationCode;
  TextEditingController numberField = TextEditingController();
  GlobalKey<FormState> phoneAuthKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> otpKey = GlobalKey();
  bool _state = true;

  @override
  Widget build(BuildContext context) {
    numberField..text = widget.phoneNumber;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Flexible(
              child: Image.asset(
            "images/otpHeading.png",
            height: MediaQuery.of(context).size.height / 3,
          )),
          Column(
            children: [
              Container(
                child: _state
                    ? null
                    : Text(
                        widget.phoneNumber,
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              Container(
                child: _state
                    ? null
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            _state = true;
                          });
                        },
                        child: Text("Enter wrong number?")),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: _state
                ? Text(
                    "We will send a one time password on your mobile number.",
                    style: TextStyle(fontFamily: "Ubuntu"),
                  )
                : Text(
                    "Please enter One Time Password we have sent to your mobile.",
                    style: TextStyle(fontFamily: "Ubuntu"),
                  ),
          ),
          Center(
            child: _state
                ? Container(
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
                        controller: numberField,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        autofillHints: [AutofillHints.telephoneNumber],
                        decoration: InputDecoration(
                            prefixIcon: CountryCodePicker(
                              initialSelection: widget.countryCode,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                            border: OutlineInputBorder(),
                            hintText: "Number",
                            hintStyle: TextStyle(color: Colors.black),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Form(
                      key: otpKey,
                      child: PinCodeTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter otp";
                          } else if (value.length != 6) {
                            return "Enter 6 digits otp";
                          } else {
                            return null;
                          }
                        },
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        appContext: context,
                        length: 6,
                        onChanged: (String value) {},
                      ),
                    ),
                  ),
          ),
          Container(
            child: _state
                ? CupertinoButton(
                    onPressed: () {
                      if (phoneAuthKey.currentState!.validate()) {
                        setState(() {
                          _state = false;
                          _mobileAuthFirebase(
                              widget.countryCode+widget.phoneNumber);
                        });
                      }
                    },
                    color: Colors.blue,
                    child: Text(
                      "Get OTP",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : CupertinoButton(
                    color: Colors.blue,
                    child: Text(
                      "Validate",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _signInManual();
                    }),
          ),
        ]));
  }

  Future<void> _mobileAuthFirebase(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) async {
        FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
        await migrateUser();
        Navigator.of(context).pop();
      },
      timeout: const Duration(seconds: 60),
      verificationFailed: (FirebaseAuthException e) async {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      },
      codeSent: (verificationId, resendToken) async {
        this._verificationCode = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<void> _signInManual() async {
    try {
      FirebaseAuth.instance.currentUser!.linkWithCredential(
          PhoneAuthProvider.credential(
              verificationId: _verificationCode,
              smsCode: otpController.value.text)).whenComplete(() => (){
      });
              await migrateUser();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5), content: Text(e.message.toString())));
    }
  }

  Future<void> migrateUser() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "verificationRequired": false,
      "phone" : widget.phoneNumber,
      "name" : widget.name
    }, SetOptions(merge: true)).then((value) => {});
  }
}

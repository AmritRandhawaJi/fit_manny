import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/model/userStateAuthentication.dart';
import 'package:fit_manny/screens/phoneOTP.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneAuthFirebase extends StatefulWidget {
  final String number;
  final String countryCode;

  PhoneAuthFirebase({required this.number, required this.countryCode});

  @override
  _PhoneAuthFirebaseState createState() => _PhoneAuthFirebaseState();
}

class _PhoneAuthFirebaseState extends State<PhoneAuthFirebase> {
  late String _verificationCode;
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> otpKey = GlobalKey();
  bool _buttonState = true;

  @override
  void initState() {
    _mobileAuthFirebase(widget.countryCode + widget.number);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Image.asset("images/otpHeading.png",
                height: MediaQuery.of(context).size.height / 2.5),
          ),
          Container(
            child: Platform.isIOS
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black)),
          ),
          Text(
            "An one time password has been sent to",
            style: TextStyle(fontFamily: "Ubuntu"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              widget.countryCode+  widget.number,
                style: TextStyle(color: Colors.black87, fontFamily: "Ubuntu"),
              ),
              SizedBox(
                width: 5.0,
              ),
              TextButton(
                  onPressed: () {
                    if (Platform.isIOS) {
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(
                        builder: (context) => MobileAuthentication(),
                      ));
                    } else if (Platform.isAndroid) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => MobileAuthentication(),
                      ));
                    }
                  },
                  child: Text("Wrong number?",
                      style: TextStyle(color: Colors.blue)))
            ],
          ),
          Padding(
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                appContext: context,
                length: 6,
                onChanged: (String value) {},
              ),
            ),
          ),
          Center(
            child: Container(
                child: _buttonState
                    ? CupertinoButton(
                        onPressed: () async {
                          if (otpKey.currentState!.validate()) {
                            _signInManual();
                            setState(() {
                              _buttonState = false;
                            });
                          }
                        },
                        color: Colors.black,
                        child: Text(
                          "Proceed",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : null),
          ),
          TextButton(
              onPressed: () {
                _mobileAuthFirebase(widget.number);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("OTP Resend")));
              },
              child: Text("Resend"))
        ],
      ),
    );
  }

  Future<void> _mobileAuthFirebase(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signInWithAutoVerify(credential);
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

  Future<void> _signInWithAutoVerify(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _buttonState = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => UserStateAuthentication(countryCode: widget.countryCode,number: widget.number,),
      ));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _buttonState = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  Future<void> _signInManual() async {
    final phoneAuth = PhoneAuthProvider.credential(
        verificationId: _verificationCode, smsCode: otpController.text);
    try {
      setState(() {
        _buttonState = false;
      });
      await FirebaseAuth.instance.signInWithCredential(phoneAuth);
      if (Platform.isIOS) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => UserStateAuthentication(countryCode: widget.countryCode,number: widget.number,),
        ));
      } else if (Platform.isAndroid) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UserStateAuthentication(countryCode: widget.countryCode,number: widget.number,),
        ));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _buttonState = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5), content: Text(e.message.toString())));
    }
  }
}

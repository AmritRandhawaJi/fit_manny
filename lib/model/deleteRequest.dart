import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/widgets/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class DeleteAccountRequest extends StatefulWidget {
  @override
  _DeleteAccountRequestState createState() => _DeleteAccountRequestState();
}

class _DeleteAccountRequestState extends State<DeleteAccountRequest> {
  bool _loading = false;
  User? user = FirebaseAuth.instance.currentUser;
  late String _verificationCode;
  TextEditingController numberField = TextEditingController();
  GlobalKey<FormState> phoneAuthKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> otpKey = GlobalKey();
  bool _state = false;
  bool _state2 = false;

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
          Container(
              child: _state
                  ? Padding(
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
                    )
                  : null),
          Container(
            child:_state ? CupertinoButton(
                color: Colors.red,
                child: Text("Confirm",style: TextStyle(color: Colors.white),), onPressed: (){
                  _deleteUser();

            }) :CupertinoButton(
                color: Colors.black,
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  setState(() {
                    _loading = true;
                    _state = true;
                  });
                  if(otpKey.currentState!.validate()){
                    _signInManual();
                  }
                }),
          ),
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

  FutureOr onGoBack(value) {
    setState(() {});
    if (value) {
      _deleteUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Need to verify first"),
      ));
    }
  }

  Future<void> _deleteUser() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete().then((value) => (){
        print("delete");
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _signInManual() async {
    try {
      final phoneAuth = PhoneAuthProvider.credential(
          verificationId: _verificationCode, smsCode: otpController.value.text);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(phoneAuth);
      setState(() {
        _loading = false;
        _state = true;
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5), content: Text(e.message.toString())));
    }
  }
}

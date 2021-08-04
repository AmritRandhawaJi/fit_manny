import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_manny/screens/decision.dart';
import 'package:fit_manny/screens/emailLoginUi.dart';
import 'package:fit_manny/widgets/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> stateKey = GlobalKey();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    if (Platform.isIOS) {
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(
                        builder: (context) => Decision(),
                      ));
                    } else if (Platform.isAndroid) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Decision(),
                      ));
                    }
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
                   Image.asset("assets/forget.png",width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 3.5,),
              ],
            ),
            Form(
              key: stateKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email!.isEmpty) {
                      return "Email is required";
                    } else if (!EmailValidator.validate(email)) {
                      return "Email invalid";
                    } else {
                      return null;
                    }
                  },
                  autofillHints: [AutofillHints.email],
                  controller: emailController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "What's your email address?",
                      hintStyle: TextStyle(color: Colors.black),
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.close),
                        onTap: () {
                          emailController.text = "";
                        },
                      ),
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: "Enter your email",
                      labelStyle: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  "Forget password? don't worry we'll assist you.",
                  style: TextStyle(

                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Ubuntu"),
                )),
            Container(
              child: _loading ? Platform.isIOS
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black)) : null,
            ),
            CupertinoButton(
              onPressed: () {
                if (stateKey.currentState!.validate()) {
                  setState(() {
                    _loading = true;
                  });
                  _validation();
                }
              },
              child: Text(
                "Reset",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black,
            ),
            CupertinoButton(child: Text("Login",style: TextStyle(color: Colors.white),), onPressed: (){
              if (Platform.isIOS) {
                Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(builder: (context) => EmailLoginUI(),));
              }
              else if (Platform.isAndroid) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => EmailLoginUI(),));
              }
            },color: Colors.black,),
            Column(
              children: [
                Text(
                  "Need more help?",
                ),
                TextButton(
                    onPressed: () {
                      Alerts(
                        "Write your concern at Helpdesk@fitmanuk.com",
                        "Customer Support",
                        context,
                      ).show();
                    },
                    child: Text("Customer support",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Ubuntu")))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _validation() async {

    bool _error = false;
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text)
        .catchError((e) {
      _error = true;
    });

    if (_error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User not found or may deleted"),
      ));
      setState(() {
_loading = false;
      });
    } else if (!_error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password reset email has been sent"),
      ));
    }
  }
}

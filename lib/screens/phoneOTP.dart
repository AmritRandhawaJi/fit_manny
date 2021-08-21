import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:fit_manny/screens/phoneAuthentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MobileAuthentication extends StatefulWidget {
  @override
  _MobileAuthenticationState createState() => _MobileAuthenticationState();
}

class _MobileAuthenticationState extends State<MobileAuthentication> {
  String countryCode = "+91";
  TextEditingController numberField = TextEditingController();
  GlobalKey<FormState> phoneAuthKey = GlobalKey<FormState>();


  @override
  void dispose() {
    numberField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,),
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          Text(
            "Create with phone number",
            style: TextStyle(fontSize: 18,fontFamily: "Ubuntu"),
          ),
          Flexible(child: Image.asset("images/phoneHeading.png",height: MediaQuery.of(context).size.height/2.5,)),
          Center(
            child: Container(
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
                      labelStyle: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Text(
                "We will send a one time password on your mobile number.",style: TextStyle(fontFamily: "Ubuntu"),),
          ),
          CupertinoButton(
            onPressed: () {
              if (phoneAuthKey.currentState!.validate()) {

                if (Platform.isIOS) {
                  Navigator.of(context).pushReplacement(CupertinoPageRoute(
                    builder: (context) => PhoneAuthFirebase(countryCode: countryCode,number: numberField.value.text,),
                  ));
                } else if (Platform.isAndroid) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PhoneAuthFirebase(countryCode: countryCode,number: numberField.value.text,),
                  ));
                }
              }
            },
            color: Colors.blue,
            child: Text(
              "Get OTP",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ]));
  }
}

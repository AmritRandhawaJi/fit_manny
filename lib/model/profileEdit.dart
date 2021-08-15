import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  String name = "";
  String email = "";
  String phone = "";
  FirebaseFirestore server = FirebaseFirestore.instance;

  final User _user = FirebaseAuth.instance.currentUser!;

  final GlobalKey<FormState> phoneAuthKey = GlobalKey<FormState>();

  String countryCode = "+91";

  final TextEditingController _numberField = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();

  Future<dynamic> _data() async {
    await server
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        name = documentSnapshot.get("name");
        phone = documentSnapshot.get("phone");
        email = documentSnapshot.get("email");
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
    return SafeArea(
      child: Scaffold(
        body : Column(
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15,top: 20),
                      child: Icon(Icons.close),
                    ))
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Text("Edit profile"),
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
                  child: _user.emailVerified
                      ? Container(
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
                        )
                      : Padding(
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
                      )),
            ),
            CupertinoButton(
                color: Colors.black,
                child: Text("Update"),
                onPressed: () {
                  if (_nameKey.currentState!.validate()) {
                    if (_emailKey.currentState != null) {
                      if (_emailKey.currentState!.validate()) {
                        updateEmail();
                        print("object");                      }
                    } else if (phoneAuthKey.currentState != null) {
                      if (phoneAuthKey.currentState!.validate()) {
                        updatePhone();
                        print("object2");
                      }
                      }
                    }
                })          ],
        ),
      ),
    );
  }

  updateEmail() async {
  await  FirebaseFirestore.instance.collection("users").doc(_user.uid).set({
      "name": _nameController.value.text,
      "email": _emailController.value.text
    }, SetOptions(merge: true)).then((value) => {

    });
Navigator.of(context).pop();
  }

  updatePhone() async{
   await FirebaseFirestore.instance.collection("users").doc(_user.uid).set(
        {"name": _nameController.value.text, "phone": _numberField.value.text},
        SetOptions(merge: true)).then((value) => {});

      Navigator.of(context).pop();

  }

}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String mobileno;
  const ChangePasswordScreen(this.mobileno);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool showPassword = true;
  bool showConfirmPassword = true;

  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;
  TextEditingController txt_password = new TextEditingController();

  TextEditingController txt_confirmpassword = new TextEditingController();
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void chPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Wrap(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    SpinKitRing(
                      color: primaryColor,
                      size: 40.0,
                      lineWidth: 1.2,
                    ),
                    SizedBox(height: 25.0),
                    Text(
                      'Please Wait..',
                      style: grey14MediumTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    var encoded = Uri.parse(updatepassword);

    http.post(encoded,
        body: jsonEncode({
          "phone": widget.mobileno.toString(),
          "password": txt_password.text,
        }),
        headers: {"content-type": "application/json"}).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        showInSnackBar("Password Updated Successfully");
        Timer(
            Duration(seconds: 3),
            () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()),
                (Route<dynamic> route) => false));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Icon(Icons.arrow_back_rounded),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 70),
                child: Center(
                    child: Text(
                  "Reset password",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
                )),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "You are resting a new password for +91(" +
                            widget.mobileno +
                            ")\n",
                        style: const TextStyle(
                            color: Colors.black38, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: txt_password,
                      focusNode: passwordFocusNode,
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          FocusScope.of(context)
                              .requestFocus(passwordFocusNode);
                        });
                      },
                      obscureText: showPassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.black38),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () => setState(() {
                                  showPassword = !showPassword;
                                })),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      "At least 6 characters long. Must include a number and a letter.",
                      style: TextStyle(color: Colors.black12, fontSize: 12)),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: txt_confirmpassword,
                      focusNode: confirmPasswordFocusNode,
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          FocusScope.of(context)
                              .requestFocus(confirmPasswordFocusNode);
                        });
                      },
                      obscureText: showConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
                        hintStyle: TextStyle(color: Colors.black38),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () => setState(() {
                                  showConfirmPassword = !showConfirmPassword;
                                })),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 250, right: 20),
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (txt_password.text == txt_confirmpassword.text) {
                      chPassword();
                    } else {
                      showInSnackBar("Confirm Password Missmatch");
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

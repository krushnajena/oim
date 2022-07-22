import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/otp_screen.dart';
import 'package:oim/screens/signin_using_password.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  final String userType;
  SignInScreen(this.userType);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController txt_mobileno = new TextEditingController();

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void mobileNoCheck() async {
    if (txt_mobileno.text != "") {
      if (txt_mobileno.text.length == 10) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            // return object of type Dialog
            return Dialog(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
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
        print(get_UserDetailsByMobileNoAndUserType +
            txt_mobileno.text +
            "/" +
            widget.userType);
        var encoded = Uri.parse(get_UserDetailsByMobileNoAndUserType +
            txt_mobileno.text +
            "/" +
            widget.userType);
        http.get(encoded).then((value) async {
          print(value.statusCode);
          if (value.statusCode == 200) {
            Map mjson;
            mjson = json.decode(value.body);
            if (mjson["data"]["User"].length == 0) {
              Navigator.of(context).pop();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OtpScreen(txt_mobileno.text, widget.userType)));
            } else {
              Navigator.of(context).pop();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignInUsingPassword(
                          txt_mobileno.text, widget.userType)));
            }
          } else {
            Navigator.pop(context);
            showInSnackBar("Sommthing Going Wrong. Please Try agian later.");
          }
        }).catchError((onError) {});
      } else {
        showInSnackBar("Mobile No Should Be 10 Digits");
      }
    } else {
      showInSnackBar("Please Enter Mobile No");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back_rounded)),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 110, left: 40, right: 30),
                child: Text(
                  "Enter Phone number for verification",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 27,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 40, right: 60),
                child: Text(
                  "This number will be used for all communication. You shall receive an  SMS with code for verification.",
                  style: TextStyle(color: Colors.black38, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    controller: txt_mobileno,
                    autocorrect: true,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '+91 Enter your mobile number',
                      prefixIcon: IconButton(
                        icon: Image.asset(
                          'images/flagnew.jpg',
                          width: 30.0,
                          height: 30.0,
                        ),
                        onPressed: null,
                      ),
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    mobileNoCheck();
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 230, left: 10, right: 10),
                child: Image.asset(
                  "images/simage1.png",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

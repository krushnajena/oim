import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oim/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSupportScreen extends StatefulWidget {
  const UserSupportScreen({Key? key}) : super(key: key);

  @override
  State<UserSupportScreen> createState() => _UserSupportScreenState();
}

class _UserSupportScreenState extends State<UserSupportScreen> {
  TextEditingController txt_name = new TextEditingController();

  TextEditingController txt_email = new TextEditingController();
  TextEditingController txt_phone = new TextEditingController();

  TextEditingController txt_message = new TextEditingController();
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    txt_name.text = preferences.getString("name").toString();
    txt_email.text = preferences.getString("email").toString();
    txt_phone.text = preferences.getString("phoneno").toString();
  }

  void submit() async {
    if (txt_name.text != "") {
      if (txt_email.text != "") {
        if (txt_phone.text != "") {
          if (txt_message.text != "") {
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
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pop();
              showInSnackBar("Your Query Hasbeen submitted.");
            });
          } else {
            showInSnackBar("Please Enter Message");
          }
        } else {
          showInSnackBar("Please Enter Phone No");
        }
      } else {
        showInSnackBar("Please Enter Email");
      }
    } else {
      showInSnackBar("Please Enter Name");
    }
  }

  @override
  Widget build(BuildContext context) {

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth =MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Support"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.blue,
              child: const Padding(
                padding: EdgeInsets.only(left: 20, top: 40, right: 20),
                child: Text(
                  "Please fill out the form below and we will get back to you as soon as possible.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.only(top: 110, left: 30, right: 30),
                child: SizedBox(
                    height: 567,
                    width: deviceWidth * 0.9,
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 20, left: 25, right: 25),
                              width: deviceWidth * 0.9,
                              child: TextField(
                                controller: txt_name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '* Name',
                                  hintText: 'Name',
                                ),
                                autofocus: false,
                              )),
                          Container(
                              padding: EdgeInsets.only(top: 20, left: 25, right: 25),
                              width: deviceWidth * 0.9,
                              child: TextField(
                                controller: txt_email,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '* Email',
                                  hintText: 'Email',
                                ),
                                autofocus: false,
                              )),
                          Container(
                              padding: EdgeInsets.only(top: 20, left: 25, right: 25),
                              width: deviceWidth * 0.9,
                              child: TextField(
                                controller: txt_phone,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '* Phone',
                                  hintText: 'Phone',
                                ),
                                autofocus: false,
                              )),
                          Container(
                              padding: EdgeInsets.only(top: 20, left: 25, right: 25),
                              width: deviceWidth * 0.9,
                              child: TextField(
                                maxLines: 8,
                                controller: txt_message,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '* Message',
                                  hintText: 'Message',
                                ),
                                autofocus: false,
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            height: 50,
                            width: 300,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              onPressed: () {
                                submit();
                              },
                              color: Colors.blue,
                              child: Padding(
                                padding: EdgeInsets.only(left: 95),
                                child: Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

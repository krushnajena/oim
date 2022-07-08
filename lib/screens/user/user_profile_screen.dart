import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController txt_name = new TextEditingController();

  TextEditingController txt_email = new TextEditingController();
  TextEditingController txt_phone = new TextEditingController();

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void submit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var encoded = Uri.parse(post_register);
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

    http.post(encoded,
        body: jsonEncode({
          "name": txt_name.text,
          "email": txt_email.text,
          "id": preferences.getString("userid")
        }),
        headers: {"content-type": "application/json"}).then((value) {
      if (value.statusCode == 200) {
        preferences.setString("email", txt_email.text);
        preferences.setString("name", txt_name.text);
        showInSnackBar("Your Profile Has Been Updated");
      }
      Navigator.of(context).pop();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MY PROFILE",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.blue,
          ),
          Padding(
            padding: EdgeInsets.only(top: 70, left: 15, right: 15),
            child: SizedBox(
              height: 600,
              width: 400,
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 310),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15, top: 60),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.blue,
                              child: IconButton(
                                icon: Icon(
                                  Icons.person_rounded,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, top: 40),
                          width: 200,
                          child: TextField(
                            controller: txt_name,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              hintText: 'Name',
                            ),
                            autofocus: false,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15, top: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.yellow[900],
                              child: IconButton(
                                icon: Icon(
                                  Icons.phone_android_sharp,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 8,
                            left: 30,
                          ),
                          width: 200,
                          child: TextField(
                            readOnly: true,
                            controller: txt_phone,
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              hintText: 'Number',
                            ),
                            autofocus: false,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15, top: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.blue,
                              child: IconButton(
                                icon: Icon(
                                  Icons.email,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 8,
                            left: 30,
                          ),
                          width: 200,
                          child: TextField(
                            controller: txt_email,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Set Email',
                            ),
                            autofocus: false,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        submit();
                      },
                      child: Container(
                        height: 35,
                        width: 240,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Image.asset(
                        "images/1.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40, left: 160),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Container(
                  height: 90,
                  width: 90,
                  color: Colors.white,
                  child: Image.asset("images/6.jpeg")),
            ),
          ),
        ]),
      ),
    );
  }
}

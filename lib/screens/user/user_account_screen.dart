import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/flash_screen.dart';
import 'package:oim/screens/seller/app_settings_screen.dart';
import 'package:oim/screens/seller/seller_help_center.dart';
import 'package:oim/screens/user/notification_screen.dart';
import 'package:oim/screens/user/user_hep_center_screen.dart';
import 'package:oim/screens/user/user_profile_screen.dart';
import 'package:oim/screens/user/user_support_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({Key? key}) : super(key: key);

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  String name = "";
  int noofunreadnotifications = 0;

  void getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name")!;
    });
    var nencoded = Uri.parse(
        getunseennotifications + preferences.getString("userid").toString());
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        print("8778678437898877549889989898899889989889");
        print(getunseennotifications +
            preferences.getString("userid").toString());
        print(mnjson);
        setState(() {
          noofunreadnotifications = mnjson["data"]["notifications"].length;
        });
        print(noofunreadnotifications);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Account",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
                  },
                  child: new Stack(
                    children: <Widget>[
                      new Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      new Positioned(
                        right: 0,
                        child: new Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: new Text(
                            '$noofunreadnotifications',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            color: Colors.white,
            height: 100,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 50,
                    width: 50,
                    child: Image.asset("images/humanicon.png")),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileScreen()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Change Your Account Information",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              )
            ]),
          ),
          Container(
            height: 8,
            color: Colors.grey[200],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppSettingsScreen()));
                  },
                  child: Container(
                    height: 60,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Image.asset("images/8.jpeg"),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "App Settings",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserHelpCenterScreen()));
                  },
                  child: Container(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Image.asset("images/3.jpeg"),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Help Center",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String googleUrl =
                        'https://play.google.com/store/apps/details?id=com.oim.android';

                    print(googleUrl);

                    await launch(googleUrl);
                  },
                  child: Container(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Image.asset("images/4.jpeg"),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Rate Us",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                              title: new Text("Confirmation"),
                              content: new Text("Do you want to logout?"),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    preferences.clear();

                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                FlashScreen()),
                                        (Route<dynamic> route) => false);
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text(
                                    "Exit",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                  },
                  child: Container(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Image.asset("images/2.jpeg"),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Log Out",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )

          //Rajsmita
          //Soumya
        ],
      )),
    );
  }
}

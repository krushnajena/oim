import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:oim/screens/user/user_bottom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotification();
  }

  bool showhide = false;
  List notifications = [];

  void getNotification() async {
    setState(() {
      notifications = [];
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(
        get_notifications + preferences.getString("userid").toString());
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          notifications = mnjson["data"]["notifications"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10),
          child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      color: notifications[index]["isSeen"] == false
                          ? Color.fromARGB(255, 189, 220, 249)
                          : Colors.white,
                      child: InkWell(
                        onTap: () async {
                          var nencoded = Uri.parse(
                              seenNotification + notifications[index]["_id"]);
                          http.get(nencoded).then((resp) async {
                            if (resp.statusCode == 200) {
                              if (notifications[index]["notificationtype"]
                                      .toString() ==
                                  "product") {
                                var a = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsScreen(
                                                notifications[index]["pcsid"]
                                                    .toString())));
                                getNotification();
                              }
                            }
                          });
                        },
                        child: SizedBox(
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Image.network(
                                        baseUrl +
                                            notifications[index]["image"]
                                                .toString(),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          notifications[index]["tittle"]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                              notifications[index]
                                                      ["description"]
                                                  .toString(),
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Color.fromARGB(255, 208, 208, 208),
                    ),
                  ],
                );
              }),
        ));
  }
}

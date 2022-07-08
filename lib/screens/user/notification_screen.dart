import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/product_details_screen.dart';
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
    var nencoded = Uri.parse(get_notifications);
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
        body: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      if ((preferences.getString("noofreadnotifications") ??
                              "") ==
                          "") {
                        preferences.setString("noofreadnotifications", "1");
                      } else {
                        int noofreadnotifications = int.parse(preferences
                            .getString("noofreadnotifications")
                            .toString());
                        preferences.setString("noofreadnotifications",
                            (noofreadnotifications! + 1).toString());
                      }

                      if (notifications[index]["notificationtype"].toString() ==
                          "product") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                    notifications[index]["pcsid"].toString())));
                      }
                    },
                    child: SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notifications[index]["tittle"].toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                        notifications[index]["description"]
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                ],
              );
            }));
  }
}

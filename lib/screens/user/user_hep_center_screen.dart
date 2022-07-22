import 'package:flutter/material.dart';
import 'package:oim/screens/user/user_feedback_screen.dart';
import 'package:oim/screens/user/user_report_bug_screen.dart';
import 'package:oim/screens/user/user_support_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelpCenterScreen extends StatefulWidget {
  const UserHelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<UserHelpCenterScreen> createState() => _UserHelpCenterScreenState();
}

class _UserHelpCenterScreenState extends State<UserHelpCenterScreen> {
  String userid = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("userid").toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Help Center"),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 2),
                  height: 720,
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserSupportScreen()));
                        },
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 9, left: 9),
                              child: Image.asset(
                                "images/3.jpeg",
                                height: 35,
                                width: 35,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 9, left: 9),
                              child: Text(
                                "Support",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 50),
                        child: Divider(
                          height: 10,
                          color: Colors.grey,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserFeedBackScreen()));
                        },
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 9, left: 9),
                              child: Image.asset(
                                "images/5.jpeg",
                                height: 35,
                                width: 35,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 9, left: 9),
                              child: Text(
                                "Feedback",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 50),
                        child: Divider(
                          height: 10,
                          color: Colors.grey,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserReportABugScreen()));
                        },
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 9, left: 9),
                              child: Image.asset(
                                "images/feed.png",
                                height: 35,
                                width: 35,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 9, left: 9),
                              child: Text(
                                "Report a bug",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 50),
                        child: Divider(
                          height: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Id " + userid,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ));
  }
}

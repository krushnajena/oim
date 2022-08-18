import 'package:flutter/material.dart';
import 'package:oim/screens/seller/seller_feedback_screen.dart';
import 'package:oim/screens/seller/seller_report_a_bug_screen.dart';
import 'package:oim/screens/seller/seller_support_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerHelpCenter extends StatefulWidget {
  const SellerHelpCenter({Key? key}) : super(key: key);

  @override
  State<SellerHelpCenter> createState() => _SellerHelpCenterState();
}

class _SellerHelpCenterState extends State<SellerHelpCenter> {
  String userid = "";

  void initState() {
    super.initState();
    getSellerId();
  }

  void getSellerId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("userid")!;
      print(userid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Help Center",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
                                builder: (context) => SellerSupportScreen()));
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
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellerFeedbackScreen()));
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
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SellerReportABugScreen()));
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
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 18, left: 8),
                    child: Text(
                      "Store ID " + userid,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/ad_plans_screen.dart';
import 'package:oim/screens/seller/post_add_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PromoteYourBusinessScreen extends StatefulWidget {
  const PromoteYourBusinessScreen({Key? key}) : super(key: key);

  @override
  State<PromoteYourBusinessScreen> createState() =>
      _PromoteYourBusinessScreenState();
}

class _PromoteYourBusinessScreenState extends State<PromoteYourBusinessScreen> {
  List ads = [];
  String businessName = "";
  String categoryName = "";

  void getBusinessDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      businessName = preferences.getString("businessname")!;
      categoryName = preferences.getString("businesscategory")!;
    });
    print(categoryName);
  }

  void getAds() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString("userid").toString();
    print(userid);
    var nencoded = Uri.parse(get_adds_by_sellerid + userid);
    print(get_adds_by_sellerid + userid);
    http.get(nencoded).then((value) {
      if (value.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(value.body);
        print(value.body);
        setState(() {
          ads = mnjson["data"]["result"];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAds();
    getBusinessDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffededed),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.blue,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 50, left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "PROMOTE YOUR\nSTORE & BOOST\nLISTING",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    height: 1.5),
                              ),
                              SizedBox(
                                height: 140,
                                width: 140,
                                child: Image.asset(
                                  "images/advimg4.png",
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        categoryName != "Restaurant"
                            ? Container(
                                margin: EdgeInsets.only(
                                  top: 220,
                                ),
                                height: 280,
                                width: 350,
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "images/advimg.jpg",
                                        height: 150,
                                        width: 150,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Post Free Ads On Offer Zone",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        "Oim allows 2 free ads in 30 days",
                                        style: TextStyle(color: Colors.black38),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 35,
                                        width: 300,
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PostAdScreen()));
                                          },
                                          color: Colors.blue,
                                          child: Text("Post Ads",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Container(
                          margin: categoryName != "Restaurant"
                              ? EdgeInsets.only(top: 20)
                              : EdgeInsets.only(
                                  top: 220,
                                ),
                          height: 280,
                          width: 350,
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/advimg1.jpg",
                                  height: 150,
                                  width: 150,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Advertising Plans",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height: 35,
                                  width: 300,
                                  child: RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdPlanScreen()));
                                    },
                                    color: Colors.blue,
                                    child: Text(
                                      "View Plans",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])
              ],
            ),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:oim/screens/seller/seller_privacy_policy.dart';
import 'package:oim/screens/seller/seller_terms_conditions.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              // Navigator.push(context,
              //   MaterialPageRoute(builder: (context) => AccounttPage()));
            }),
        title: Text(
          "App Settingss",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 2),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellerPrivacyPolic()));
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 9, left: 9),
                            child: Icon(
                              Icons.lock_outline,
                              size: 30,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 9, left: 9),
                            child: Text(
                              "Privacy Policy",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
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
                                    SellerTermsAndConditions()));
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 9, left: 9),
                            child: Icon(
                              Icons.contact_page,
                              size: 30,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 9, left: 9),
                            child: Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
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
            ],
          ),
        ],
      ),
    );
  }
}

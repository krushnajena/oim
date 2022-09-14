import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:oim/screens/flash_screen.dart';
import 'package:oim/screens/seller/resturent_seller_bottombar.dart';
import 'package:oim/screens/seller/seller_account_create_screen.dart';
import 'package:oim/screens/seller/seller_bottom_appbar.dart';
import 'package:oim/screens/user/user_bottom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
  }

  Future<void> check() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if ((preferences.getString("usertype") ?? "") == "") {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => FlashScreen()),
              (Route<dynamic> route) => false));
    } else {
      if (preferences.getString("usertype") == "user") {
        Timer(
            Duration(seconds: 3),
            () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => UserBottomAppBar()),
                (Route<dynamic> route) => false));
      } else {
        if ((preferences.getString("businessname") ?? "") == "") {
          Timer(
              Duration(seconds: 3),
              () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SellerAccountCreateScreen()),
                  (Route<dynamic> route) => false));
        } else {
          if (preferences.getString("businesscategory") == "Restaurant") {
            Timer(
                Duration(seconds: 3), () =>
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:
                    (BuildContext context) => RestSellerBottomAppBar()),
                    (Route<dynamic> route) => false));
          } else {
            Timer(Duration(seconds: 3), () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext context) => SellerBottomAppBar()),
                    (Route<dynamic> route) => false));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff2270ba),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Center(
                  child: Image.asset(
                "images/splash_logo.png",
                height: 180,
              )),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Image.asset(
                  "images/indian_flag.png",
                  height: 40,
                ))
          ],
        ));
  }
}

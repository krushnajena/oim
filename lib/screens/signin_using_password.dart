import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/provider/location_provider.dart';
import 'package:oim/screens/seller/resturent_seller_bottombar.dart';
import 'package:oim/screens/seller/seller_account_create_screen.dart';
import 'package:oim/screens/seller/seller_bottom_appbar.dart';
import 'package:oim/screens/user/user_set_location_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user/user_bottom_appbar.dart';

class SignInUsingPassword extends StatefulWidget {
  final String mobileNo, userType;
  SignInUsingPassword(this.mobileNo, this.userType);

  @override
  State<SignInUsingPassword> createState() => _SignInUsingPasswordState();
}

class _SignInUsingPasswordState extends State<SignInUsingPassword> {
  bool showPassword = true;
  bool showConfirmPassword = true;

  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;
  TextEditingController txt_password = new TextEditingController();

  void login() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (txt_password.text != "") {
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
      var encoded = Uri.parse(post_login);
      http.post(encoded,
          body: jsonEncode({
            "phone": widget.mobileNo.toString(),
            "password": txt_password.text,
            "usertype": widget.userType
          }),
          headers: {"content-type": "application/json"}).then((value) {
        print(value.statusCode);
        if (value.statusCode == 200) {
          Map mjson;
          mjson = json.decode(value.body);
          print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
          print(mjson);
          print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
          if (mjson["data"]["user"].length > 0) {
            if (mjson["data"]["user"][0]["email"] != null) {
              print(mjson["data"]["user"][0]);
              preferences.setString("email", mjson["data"]["user"][0]["email"]);
            } else {
              preferences.setString("email", "");
            }
            preferences.setString("name", mjson["data"]["user"][0]["name"]);
            preferences.setString("usertype", widget.userType);
            preferences.setString("phoneno", widget.mobileNo);
            preferences.setString("userid", mjson["data"]["user"][0]["_id"]);
            print(preferences.getString("userid"));
            Navigator.of(context).pop();
            if (widget.userType == "user") {
              //final locationData = Provider.of<LocationProvider>(context);
              //locationData.getCurrentPosition().then((value) async {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserBottomAppBar()),
                  (Route<dynamic> route) => false);
            } else {
              var nencoded = Uri.parse(
                  get_sellerdetalsbyuserid + mjson["data"]["user"][0]["_id"]);
              print(get_sellerdetalsbyuserid + mjson["data"]["user"][0]["_id"]);
              http.get(nencoded).then((resp) {
                if (resp.statusCode == 200) {
                  Map mnjson;
                  mnjson = json.decode(resp.body);
                  print(mnjson);
                  if (mnjson["Data"]["Seller"].length > 0) {
                    preferences.setString("businessname",
                        mnjson["Data"]["Seller"][0]["businessname"]);
                    preferences.setString("businesscategory",
                        mnjson["Data"]["Seller"][0]["businesscatagories"]);
                    preferences.setString("businesscategory",
                        mnjson["Data"]["Seller"][0]["businesscatagories"]);
                    preferences.setString(
                        "buisnessid", mnjson["Data"]["Seller"][0]["userid"]);

                    if (mnjson["Data"]["Seller"][0]["businesscatagories"] ==
                        "Restaurant") {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RestSellerBottomAppBar()),
                          (Route<dynamic> route) => false);
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerBottomAppBar()),
                          (Route<dynamic> route) => false);
                    }
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SellerAccountCreateScreen()),
                        (Route<dynamic> route) => false);
                  }
                }
              });
            }
          } else {
            Navigator.of(context).pop();
            showInSnackBar("Invalid Password");
          }
        }
      });
    } else {
      showInSnackBar("Please Enter Password");
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Icon(Icons.arrow_back_rounded),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 70),
                child: Center(
                    child: Text(
                  "Sign In",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
                )),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Enter password for +91(" +
                            widget.mobileNo +
                            ")\nThis will help you login faster next time",
                        style: const TextStyle(
                            color: Colors.black38, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: txt_password,
                      focusNode: passwordFocusNode,
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          FocusScope.of(context)
                              .requestFocus(passwordFocusNode);
                        });
                      },
                      obscureText: showPassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.black38),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () => setState(() {
                                  showPassword = !showPassword;
                                })),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      "At least 6 characters long. Must include a number and a letter.",
                      style: TextStyle(color: Colors.black12, fontSize: 12)),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 250, right: 30),
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    login();
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

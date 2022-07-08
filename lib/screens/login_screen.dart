import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/common/forgot_password_screen.dart';
import 'package:oim/screens/seller/resturent_seller_bottombar.dart';
import 'package:oim/screens/seller/seller_account_create_screen.dart';
import 'package:oim/screens/seller/seller_bottom_appbar.dart';
import 'package:oim/screens/user/user_bottom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FocusNode mobileNoFocusNode;
  late FocusNode passwordFocusNode;
  bool showPassword = false;
  TextEditingController txt_mobileno = new TextEditingController();

  TextEditingController txt_password = new TextEditingController();
  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    mobileNoFocusNode = FocusNode();
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
    mobileNoFocusNode.dispose();
  }

  void newLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
    var encoded = Uri.parse(new_login);
    http.post(encoded,
        body: jsonEncode({
          "phone": txt_mobileno.text,
          "password": txt_password.text,
        }),
        headers: {"content-type": "application/json"}).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        if (mjson["data"]["user"][0]["email"] != null) {
          print(mjson["data"]["user"][0]);
          preferences.setString("email", mjson["data"]["user"][0]["email"]);
        } else {
          preferences.setString("email", "");
        }
        preferences.setString("name", mjson["data"]["user"][0]["name"]);
        preferences.setString("usertype", mjson["data"]["user"][0]["usertype"]);
        preferences.setString("phoneno", txt_mobileno.text);
        preferences.setString("userid", mjson["data"]["user"][0]["_id"]);
        print(preferences.getString("userid"));
        Navigator.of(context).pop();
        if (mjson["data"]["user"][0]["usertype"] == "user") {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Image.asset(
                "images/login.png",
                height: 300,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: txt_mobileno,
                  focusNode: mobileNoFocusNode,
                  keyboardType: TextInputType.phone,
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(mobileNoFocusNode);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Mobile No',
                    hintStyle: const TextStyle(color: Colors.black38),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: txt_password,
                  focusNode: passwordFocusNode,
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(passwordFocusNode);
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
              SizedBox(
                height: 20,
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    newLogin();
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

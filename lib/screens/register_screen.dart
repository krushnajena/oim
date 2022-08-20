import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/provider/location_provider.dart';
import 'package:oim/screens/seller/seller_account_create_screen.dart';
import 'package:oim/screens/seller/seller_bottom_appbar.dart';
import 'package:oim/screens/user/user_bottom_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:oim/screens/user/user_set_location_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  final String mobileNo, userType, password;
  RegisterScreen(this.mobileNo, this.userType, this.password);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController txt_name = new TextEditingController();

  TextEditingController txt_email = new TextEditingController();
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void register() async {
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
    var encoded = Uri.parse(post_register);

    http.post(encoded,
        body: jsonEncode({
          "phone": widget.mobileNo.toString(),
          "name": txt_name.text,
          "email": txt_email.text,
          "password": widget.password,
          "usertype": widget.userType
        }),
        headers: {"content-type": "application/json"}).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);

        preferences.setString("email", txt_email.text);
        preferences.setString("name", txt_name.text);
        preferences.setString("usertype", widget.userType);
        preferences.setString("phoneno", widget.mobileNo);
        preferences.setString("userid", mjson["data"]["userid"]);
        Navigator.of(context).pop();
        if (widget.userType == "user") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => UserBottomAppBar()),
              (Route<dynamic> route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SellerAccountCreateScreen()),
              (Route<dynamic> route) => false);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Icon(Icons.arrow_back),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
                child: Text(
                  "Please fill in the details to create your account",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
                  child: TextField(
                    controller: txt_name,
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your Full name',
                      hintStyle: TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: Colors.transparent,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: TextField(
                    controller: txt_email,
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintText: 'Email(Optional)',
                      hintStyle: TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: Colors.transparent,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 80),
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.black38,
                          ),
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Receive status updates on",
                        style: TextStyle(color: Colors.black38)),
                    SizedBox(
                      width: 1,
                    ),
                    Image.asset(
                      "images/wpp.png",
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 110),
                child:
                    Text("Whatsapp", style: TextStyle(color: Colors.black38)),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: SizedBox(
                  height: 40,
                  width: 250,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      register();
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Image.asset("images/oimp2.jpg")
            ],
          ),
        ),
      ),
    );
  }
}

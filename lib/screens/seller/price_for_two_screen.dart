import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PriceForTwoScreen extends StatefulWidget {
  const PriceForTwoScreen({Key? key}) : super(key: key);

  @override
  State<PriceForTwoScreen> createState() => _PriceForTwoScreenState();
}

class _PriceForTwoScreenState extends State<PriceForTwoScreen> {
  TextEditingController txt_pricefortwo = new TextEditingController();
  void setPrice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("pricefortwo", txt_pricefortwo.text);
    showInSnackBar("Price for two seted successfully");
  }

  void getPrice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if ((preferences.getString("pricefortwo") ?? "") == "") {
    } else {
      txt_pricefortwo.text = preferences.getString("pricefortwo").toString();
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Price for Two"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: ListView(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: txt_pricefortwo,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      prefixText: "₹ |  ",
                      labelText: "Price",
                      suffixText: "approx"),
                  autofocus: false,
                ),
              ),
              SizedBox(
                height: 550,
              ),
              // ignore: deprecated_member_use
              SizedBox(
                height: 40,
                child: RaisedButton(
                  onPressed: () {
                    setPrice();
                  },
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      "Set Price",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}

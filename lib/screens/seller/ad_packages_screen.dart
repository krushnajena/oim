import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/ads_payment_screen.dart';

class AdPackageScreen extends StatefulWidget {
  const AdPackageScreen({Key? key}) : super(key: key);

  @override
  State<AdPackageScreen> createState() => _AdPackageScreenState();
}

class _AdPackageScreenState extends State<AdPackageScreen> {
  List ads = [];
  int sindex = 0;
  double totalPrice = 0;
  void getAds() {
    var nencoded = Uri.parse(get_ad_packages);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          ads = mnjson["data"]["addpackage"];
          //   totalPrice = double.parse(mnjson["data"][0]["offerprice"].toString());
        });
        if (ads.length > 0) {
          totalPrice = double.parse(ads[0]["offerprice"].toString());
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAds();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: 70,
          width: MediaQuery.of(context).size.width - 20,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NormalAdScreen(totalPrice)));
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Pay ₹" + totalPrice.toStringAsFixed(2),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Icon(Icons.arrow_back),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: Image.asset("images/no_ad_emoji.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.yellow[200],
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "You have already posted 2 free Ad in last 30 days.",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.black12,
                height: 30,
                thickness: 5,
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Post More Ads",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Plan Info",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline)),
                  Text("See Example",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.check, color: Colors.black54),
                  Expanded(
                    child: Text(
                        '  Post more Ads and get your product noticed in "OFFERZONE" section.',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            height: 1.5)),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.check, color: Colors.black54),
                  Text('  Package available for 180 days.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          height: 1.5)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.check, color: Colors.black54),
                  Text('  Ad will be valid for 30 days.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          height: 1.5)),
                ],
              ),
              Divider(
                color: Colors.black12,
                height: 30,
                thickness: 5,
              ),
              Center(
                child: Text("Buy Plans",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: ads.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, top: 10),
                                child: Row(
                                  children: [
                                    InkWell(
                                      child: Icon(sindex == index
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank),
                                      onTap: () {
                                        setState(() {
                                          sindex = index;
                                          totalPrice = double.parse(ads[index]
                                                  ["offerprice"]
                                              .toString());
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        ads[index]["numberofadd"].toString() +
                                            " days",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5)),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                                height: 40,
                              ),
                              Center(
                                  child: Text(
                                      "₹" + ads[index]["offerprice"].toString(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5)))
                            ],
                          ),
                        );
                      })),
              SizedBox(height: 70)
            ],
          ),
        ),
      ),
    );
  }
}

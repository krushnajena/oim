import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/ads_payment_screen.dart';
import 'package:oim/screens/seller/pay_featured_ad_screen.dart';

class BoostYourStoreToTop extends StatefulWidget {
  const BoostYourStoreToTop({Key? key}) : super(key: key);

  @override
  State<BoostYourStoreToTop> createState() => _BoostYourStoreToTopState();
}

class _BoostYourStoreToTopState extends State<BoostYourStoreToTop> {
  List ads = [];
  int sindex = 0;
  double totalPrice = 0;
  String selectedId = "";
  void getAds() {
    var nencoded = Uri.parse(get_featured_ad_package);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          ads = mnjson["data"]["adfeatures"];
          //   totalPrice = double.parse(mnjson["data"][0]["offerprice"].toString());
        });
        if (ads.length > 0) {
          totalPrice = double.parse(ads[0]["offerprice"].toString());
          selectedId = ads[0]["_id"];
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PayFeaturedAdScreen(totalPrice, selectedId)));
          },
          isExtended: true,
          backgroundColor: Colors.blue,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: SizedBox(
              width: 300,
              child: Center(
                  child: Text(
                "Pay ₹" + totalPrice.toString(),
                style: TextStyle(fontSize: 19, color: Colors.white),
              ))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                  child: Image.asset("images/advimg6.jpg"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Text(
                  "Increase footfall to your store by promoting your Store with 'Ad' tag in top position.",
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700, height: 1.5),
                  textAlign: TextAlign.justify,
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
                  Text('  Get your Store to the "Top Rankings".',
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
                                          selectedId =
                                              ads[index]["_id"].toString();
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
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

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oim/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/ad_packages_screen.dart';
import 'package:oim/screens/seller/ad_plans_screen.dart';
import 'package:oim/screens/seller/promote_your_business_screen.dart';
import 'package:oim/screens/seller/seller_product_search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class SelectProductForAdScreen extends StatefulWidget {
  const SelectProductForAdScreen({Key? key}) : super(key: key);

  @override
  State<SelectProductForAdScreen> createState() =>
      _SelectProductForAdScreenState();
}

class _SelectProductForAdScreenState extends State<SelectProductForAdScreen> {
  List products = [];
  int noOfAds = 0;
  int totalAds = 0;
  int usedAds = 0;
  List ads = [];
  void getTotalNoOfAds(String productid) async {
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

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString("userid").toString();
    print(userid);
    var nencoded = Uri.parse(get_no_of_ad_credits + userid);
    print(get_no_of_ad_credits + userid);
    http.get(nencoded).then((value) {
      if (value.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(value.body);
        print(value.body);
        if (mnjson["data"]["addpackage"].length > 0) {
          setState(() {
            totalAds = mnjson["data"]["addpackage"][0]["noofads"];
          });
        } else {
          setState(() {
            totalAds = 0;
          });
        }

        getNoOfUsedAds(productid);
      }
    });
  }

  void getNoOfUsedAds(String productid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString("userid").toString();
    print(userid);
    var nencoded = Uri.parse(get_no_of_ad_used + userid);
    print(get_no_of_ad_used + userid);
    http.get(nencoded).then((value) {
      if (value.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(value.body);
        print(value.body);

        setState(() {
          usedAds = mnjson["data"]["addpackage"];
          noOfAds = totalAds - usedAds;
        });

        if (noOfAds > 0) {
          postAd(productid);
        } else {
          Navigator.of(context).pop();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdPackageScreen()));
        }
      }
    });
  }

  void postAd(String productid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String userid = preferences.getString("userid").toString();
    var nencoded = Uri.parse(post_ad);
    http.post(nencoded, body: {
      "productid": productid,
      "userid": userid,
      "adtype": "normal"
    }).then((value) {
      print("-----------------------------");
      print(value.statusCode);
      if (value.statusCode == 200) {
        showInSnackBar("Your Ad Posted Successfully");
      }
      Navigator.of(context).pop();
    }).onError((error, stackTrace) {
      showInSnackBar("Failed Please Try Again Later");
      Navigator.of(context).pop();
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void getProducts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString("userid");
    var nencoded = Uri.parse(get_products_byuserid + userId!);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          products = mnjson["data"]["product"];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar:
          AppBar(centerTitle: true, title: Text('Select Product'), actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SellerProductSearchScreen()));
              },
              child: Icon(Icons.search)),
        )
      ]),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      double disount =
                          double.parse(products[index]["mrp"].toString()) -
                              double.parse(products[index]["sellingprice"]
                                  .toString()
                                  .toString());
                      double discountPercentage = (disount /
                              double.parse(products[index]["mrp"].toString())) *
                          100;

                      return Container(
                        height: 250,
                        child: Card(
                          child: Container(
                            height: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Stack(children: [
                                    Container(
                                        margin: EdgeInsets.all(3),
                                        height: 115,
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    16) /
                                                2,
                                        child: Image.network(
                                          baseUrl +
                                              products[index]["image"][0]
                                                  ["filename"],
                                          fit: BoxFit.fill,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 15, top: 4),
                                      child: Card(
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(150),
                                          ),
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.share,
                                              color: Colors.grey[400],
                                            ),
                                          )),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    products[index]["productname"],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 3,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                          "₹" +
                                              products[index]["mrp"].toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                      SizedBox(width: 5),
                                      Text(
                                          "₹" +
                                              products[index]["sellingprice"]
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(width: 5),
                                      Text(
                                        discountPercentage.toStringAsFixed(2) +
                                            "%",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 8.0, right: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 10,
                                          ),
                                          Text(
                                              "  Views : " +
                                                  products[index]["views"]
                                                      .toString(),
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          products[index]["instock"]
                                              ? "In Stock"
                                              : "Stock Out",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: products[index]["instock"]
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: OutlineButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      CupertinoAlertDialog(
                                                        title: new Text(
                                                            "Confirmation"),
                                                        content: new Text(
                                                            "Do you want to display '" +
                                                                products[index][
                                                                    "productname"] +
                                                                "' on offerzone section. "),
                                                        actions: <Widget>[
                                                          CupertinoDialogAction(
                                                            isDefaultAction:
                                                                true,
                                                            child:
                                                                Text("Post Ad"),
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              getTotalNoOfAds(
                                                                  products[
                                                                          index]
                                                                      ["_id"]);
                                                            },
                                                          ),
                                                          CupertinoDialogAction(
                                                            child: Text("Exit"),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          )
                                                        ],
                                                      ));
                                            },
                                            child: Container(
                                              height: 15,
                                              width: 100,
                                              child: Center(
                                                child: const Text("Post Ad",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 260,
                  ),
                ),
                SliverGrid.extent(
                  maxCrossAxisExtent: 250,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 2.5,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

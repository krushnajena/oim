import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/products_list_screen.dart';
import 'package:oim/screens/seller/seller_product_details_screen.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class SellerStoreViewScreen extends StatefulWidget {
  const SellerStoreViewScreen({Key? key}) : super(key: key);

  @override
  State<SellerStoreViewScreen> createState() => _SellerStoreViewScreenState();
}

class _SellerStoreViewScreenState extends State<SellerStoreViewScreen> {
  String storename = "";
  String imageUrl = "";
  String address = "";
  double lat = 0;
  double lang = 0;
  String mobileNo = "";
  String categoryId = "";
  int nooffollwers = 0;
  List products = [];
  List catelouges = [];
  bool? follewed;

  double ratting = 0;
  int noofrattings = 0;
  double appliedRatting = 0;
  double oneStar = 0;
  double twoStar = 0;
  double threeStar = 0;
  double fourStar = 0;
  double fiveStar = 0;
  void getRattings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var encoded =
        Uri.parse(get_rattings + preferences.getString("userid").toString());
    print("##########################zeeeeeerrr7777777777777777777777");

    print("##########################zeeeeeerrr7777777777777777777777");
    http.get(encoded).then((value) {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        double total = 0;
        for (int i = 0; i < mjson["data"]["storeratting"].length; i++) {
          total = total +
              double.parse(mjson["data"]["storeratting"][i]["applied_ratting"]
                  .toString());
          if (double.parse(mjson["data"]["storeratting"][i]["applied_ratting"]
                  .toString()) >
              4) {
            setState(() {
              fiveStar = fiveStar + 1;
            });
          } else if (double.parse(mjson["data"]["storeratting"][i]
                      ["applied_ratting"]
                  .toString()) >
              3) {
            setState(() {
              fourStar = fourStar + 1;
            });
          } else if (double.parse(mjson["data"]["storeratting"][i]
                      ["applied_ratting"]
                  .toString()) >
              2) {
            setState(() {
              threeStar = threeStar + 1;
            });
          } else if (double.parse(mjson["data"]["storeratting"][i]
                      ["applied_ratting"]
                  .toString()) >
              1) {
            setState(() {
              twoStar = twoStar + 1;
            });
          } else if (double.parse(mjson["data"]["storeratting"][i]
                      ["applied_ratting"]
                  .toString()) >
              0) {
            setState(() {
              oneStar = oneStar + 1;
            });
          }
        }

        if (total > 0) {
          setState(() {
            noofrattings = mjson["data"]["storeratting"].length;
            ratting = total / mjson["data"]["storeratting"].length;
          });
        }
      }
    });
  }

  void getSellerDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded =
        Uri.parse(get_sellerdetalsbyuserid + preferences.getString("userid")!);

    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        if (mnjson["Data"]["Seller"].length > 0) {
          setState(() {
            storename = mnjson["Data"]["Seller"][0]["businessname"];
            imageUrl = baseUrl + mnjson["Data"]["Seller"][0]["photo"];
            address = mnjson["Data"]["Seller"][0]["streetaddress"];
            lat = mnjson["Data"]["Seller"][0]["latitude"];
            lang = mnjson["Data"]["Seller"][0]["longitude"];
            mobileNo = mnjson["Data"]["Seller"][0]["businesscontactinfo"];
            categoryId = mnjson["Data"]["Seller"][0]["businesscatagories"];
          });
          getCatelouges();
        }
      }
    });
  }

  void getCatelouges() async {
    var nencoded = Uri.parse(get_catelogues + categoryId);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          catelouges = mnjson["data"]["catlog"];
        });
      }
    });
  }

  void getProducts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded =
        Uri.parse(get_products_byuserid + preferences.getString("userid")!);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          products = mnjson["data"]["product"];
        });
        print("*****************************************");
        print(products.length);
        print("*****************************************");
      }
    });
  }

  void getNoOfFollers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded =
        Uri.parse(get_follwers_by_sellerid + preferences.getString("userid")!);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          nooffollwers = mnjson["data"]["followers"].length;
        });
      }
    });
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
    getSellerDetails();
    getProducts();
    getNoOfFollers();
    getRattings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(storename),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
              minHeight: 250,
              maxHeight: 250,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            storename,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 60,
                            width: 50,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Status()));
                                },
                                child: imageUrl != ""
                                    ? Image.asset(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : SizedBox(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text(ratting.toStringAsFixed(2)),
                        RatingBar(
                          ignoreGestures: true,
                          itemSize: 20,
                          allowHalfRating: true,
                          initialRating: ratting,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          ratingWidget: RatingWidget(
                            empty: Icon(Icons.star_border,
                                color: primaryColor, size: 20),
                            full: Icon(
                              Icons.star,
                              color: primaryColor,
                              size: 20,
                            ),
                            half: Icon(Icons.star_border,
                                color: primaryColor, size: 20),
                          ),
                          onRatingUpdate: (value) {
                            print(value);
                          },
                        ),
                        Text(
                          "(" + noofrattings.toString() + ")",
                        ),
                        InkWell(
                          onTap: () {},
                          child: Image.asset(
                            "images/star.png",
                            height: 22,
                            width: 22,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10),
                    child: Row(
                      children: [
                        Text(address),
                        Text(
                          "Open",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            products.length.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Product",
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "$nooffollwers",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Followers",
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                        width: 130,
                        child: follewed != null
                            ? follewed == false
                                ? RaisedButton(
                                    onPressed: () {},
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : RaisedButton(
                                    onPressed: () {},
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'Un Follow',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                            : SizedBox(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          final Uri launchUri = Uri(
                            scheme: 'tel',
                            path: mobileNo,
                          );
                          await launchUrl(launchUri);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                              child: Icon(
                                Icons.call,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              "CALL",
                              style: TextStyle(color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          String name = Uri.encodeComponent(storename);
                          name = name.replaceAll('%20', '+');

                          String googleUrl =
                              'https://www.google.com/maps/search/?api=1&query=$lat,$lang';

                          print(googleUrl);

                          await launch(googleUrl);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                              child: Icon(
                                Icons.directions,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              "DIRECTION",
                              style: TextStyle(color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              border: Border.all(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                            child: Icon(
                              Icons.share,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            "SHARE",
                            style: TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey[350]),
                ],
              ),
            )),
            SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
              minHeight: 92,
              maxHeight: 92,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: catelouges.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 30),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>Status()));
                                  },
                                  child: Image.network(
                                    baseUrl + catelouges[index]["image"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              catelouges[index]["cataloguename"],
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            )),
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
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerProductDetailsScreen(
                                  products[index]["_id"].toString())));
                    },
                    child: SizedBox(
                      height: 220,
                      width: 170,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      baseUrl +
                                          products[index]["image"][0]
                                              ["filename"],
                                    )),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "₹" +
                                    products[index]["sellingprice"].toString(),
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "₹" + products[index]["mrp"].toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              Text(
                                discountPercentage.toStringAsFixed(2) + "% Off",
                                style: TextStyle(color: Colors.green),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(products[index]["productname"])
                        ],
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
                mainAxisExtent: 283,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

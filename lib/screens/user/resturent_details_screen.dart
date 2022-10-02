import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/products_list_screen.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:oim/screens/user/restrurentomagesscreen.dart';
import 'package:oim/screens/user/storerattingscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ResturentDetailsScreen extends StatefulWidget {
  final String userid;
  ResturentDetailsScreen(this.userid);
  @override
  State<ResturentDetailsScreen> createState() => _ResturentDetailsScreenState();
}

class _ResturentDetailsScreenState extends State<ResturentDetailsScreen> {
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

  List<Widget> images = [];
  List food = [];
  List amb = [];
  List img = [];
  bool isImageSliderLoaded = false;
  String selectedItem = "food";

  getImageSlider() async {
    setState(() {
      images = [];
      food = [];
      amb = [];
      img = [];
    });

    var encoded = Uri.parse(getRestaurentImageBySellerId + widget.userid);
    print(get_image_banner);
    http.get(encoded).then((value) async {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson);

        for (int i = 0; i < mjson["data"]["sellerimages"].length; i++) {
          if (mjson["data"]["sellerimages"][i]["type"] == "banner") {
            setState(() {
              images.add(Image.network(
                  baseUrl + mjson["data"]["sellerimages"][i]["image"],
                  fit: BoxFit.fill));
            });
          }

          if (mjson["data"]["sellerimages"][i]["type"] == "food") {
            setState(() {
              food.add(
                mjson["data"]["sellerimages"][i]["image"],
              );
            });
          }
          if (mjson["data"]["sellerimages"][i]["type"] == "ambience") {
            setState(() {
              amb.add(
                mjson["data"]["sellerimages"][i]["image"],
              );
            });
          }
          if (mjson["data"]["sellerimages"][i]["type"] == "menu") {
            setState(() {
              img.add(
                mjson["data"]["sellerimages"][i]["image"],
              );
            });
          }
        }
        setState(() {
          isImageSliderLoaded = true;
        });
      }
    }).catchError((onError) {});
  }

  void getRattings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var encoded = Uri.parse(get_rattings + widget.userid);
    print("##########################zeeeeeerrr7777777777777777777777");

    print(get_rattings + widget.userid);
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
          if (ratting < 1) {
            setState(() {
              ratting = 0.5;
            });
          } else if (ratting < 1.5) {
            setState(() {
              ratting = 1;
            });
          } else if (ratting < 2) {
            setState(() {
              ratting = 1.5;
            });
          } else if (ratting < 2.5) {
            setState(() {
              ratting = 2;
            });
          } else if (ratting < 3) {
            setState(() {
              ratting = 2.5;
            });
          } else if (ratting < 3.5) {
            setState(() {
              ratting = 3;
            });
          } else if (ratting < 4) {
            setState(() {
              ratting = 3.5;
            });
          } else if (ratting < 4.5) {
            setState(() {
              ratting = 4;
            });
          } else if (ratting < 5) {
            setState(() {
              ratting = 4.5;
            });
          } else {
            setState(() {
              ratting = 5;
            });
          }
        }
      }
    });
  }

  void getSellerDetails() async {
    var nencoded = Uri.parse(get_sellerdetalsbyuserid + widget.userid);
    print("seller id " + widget.userid);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        if (mnjson["Data"]["Seller"].length > 0) {
          setState(() {
            storename = mnjson["Data"]["Seller"][0]["businessname"];
            imageUrl = baseUrl + mnjson["Data"]["Seller"][0]["photo"];
            address = mnjson["Data"]["Seller"][0]["streetaddress"] +
                ", " +
                mnjson["Data"]["Seller"][0]["landmark"];
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

  void applyRatting() async {}
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
    var nencoded = Uri.parse(get_products_byuserid + widget.userid);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);

        for (int i = 0; i < mnjson["data"]["product"].length; i++) {
          if (mnjson["data"]["product"][i]["isdeleted"] == false &&
              mnjson["data"]["product"][i]["instock"] == true) {
            setState(() {
              products.add(mnjson["data"]["product"][i]);
            });
          }
        }
        setState(() {});
        print("*****************************************");
        print(products.length);
        print("*****************************************");
      }
    });
  }

  void getNoOfFollers() async {
    var nencoded = Uri.parse(get_follwers_by_sellerid + widget.userid);
    print("%%%%%%%%%%%%%%%%%%%%%%%%%");
    print(get_follwers_by_sellerid + widget.userid);
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

  void Follow() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(
        follow + preferences.getString("userid")! + "/" + widget.userid);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          follewed = true;
        });
        showInSnackBar("You Have Followed " + storename);
      }
    });
  }

  void UnFollow() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(
        un_follow + preferences.getString("userid")! + "/" + widget.userid);
    print(un_follow + preferences.getString("userid")! + "/" + widget.userid);
    http.post(nencoded).then((resp) {
      print(resp.statusCode);
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          follewed = false;
        });
        showInSnackBar("You Have Un-Followed " + storename);
      }
    });
  }

  void getFollowedOrNot() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(get_follwed_or_not +
        preferences.getString("userid")! +
        "/" +
        widget.userid);
    http.get(nencoded).then((resp) {
      print("aaaaaaaaaaaaaaaaaaaa");
      print(resp.statusCode);
      print("aaaaaaaaaaaaaaaaaaaaaaa");
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        print("aaaaaaaaaaaaaaaaaaaa");
        print(mnjson["data"]);
        print("aaaaaaaaaaaaaaaaaaaaaaa");
        if (mnjson["data"]["followers"].length > 0) {
          setState(() {
            follewed = true;
          });
        } else {
          setState(() {
            follewed = false;
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSellerDetails();
    getProducts();
    getNoOfFollers();
    getFollowedOrNot();
    getRattings();
    getImageSlider();
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
                            half: Icon(Icons.star_half,
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StoreRattingScreen(
                                        widget.userid,
                                        storename,
                                        address,
                                        imageUrl)));
                          },
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
                                    onPressed: () {
                                      Follow();
                                    },
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
                                    onPressed: () {
                                      UnFollow();
                                    },
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'Following',
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
              minHeight: 210,
              maxHeight: 210,
              child: ImageSlideshow(
                width: double.infinity,
                height: 200,
                initialPage: 0,
                indicatorColor: Colors.blue,
                indicatorBackgroundColor: Colors.grey,
                children: images,
                isLoop: false,
              ),
            )),
            SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                    minHeight: 20,
                    maxHeight: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ))),
            SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                    minHeight: 50,
                    maxHeight: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResturentImagesScreen(
                                                widget.userid)));
                              },
                              child:
                                  Text("Food (" + food.length.toString() + ")"),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResturentImagesScreen(
                                                widget.userid)));
                              },
                              child: Text(
                                  "Ambience (" + amb.length.toString() + ")"),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResturentImagesScreen(
                                                widget.userid)));
                              },
                              child:
                                  Text("Menu (" + img.length.toString() + ")"),
                            ),
                          ],
                        ),
                      ],
                    ))),
            SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                    minHeight: 150,
                    maxHeight: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "About Restaurant",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}

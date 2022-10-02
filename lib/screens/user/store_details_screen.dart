import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/products_list_screen.dart';
import 'package:oim/screens/user/all_categories_screen.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:oim/screens/user/storerattingscreen.dart';
import 'package:oim/screens/user/subcategory_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetailsScreen extends StatefulWidget {
  final String userid;
  StoreDetailsScreen(this.userid);
  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
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
  String opeingText = "";
  bool isClosed = false;
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

  String twlevehourtime(int time) {
    if (time == 13) {
      return "01";
    } else if (time == 14) {
      return "02";
    } else if (time == 15) {
      return "03";
    } else if (time == 16) {
      return "04";
    } else if (time == 17) {
      return "05";
    } else if (time == 18) {
      return "06";
    } else if (time == 19) {
      return "07";
    } else if (time == 20) {
      return "08";
    } else if (time == 21) {
      return "09";
    } else if (time == 22) {
      return "10";
    } else if (time == 23) {
      return "11";
    } else {
      return "12";
    }
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

          DateTime date = DateTime.now();

          String day = DateFormat('EEEE').format(date);

          if (day == "Sunday") {
            if (mnjson["Data"]["Seller"][0].containsKey("sundayopeningtime")) {
              int openingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["sundayopeningtime"]
                  .toString()
                  .split(':')[0]);
              int closingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["sundayclosingtime"]
                  .toString()
                  .split(':')[0]);
              if (openingtime <= date.hour && closingtime > date.hour) {
                opeingText = "Open . Closes " +
                    twlevehourtime(closingtime) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["sundayclosingtime"]
                        .toString()
                        .split(':')[1];
                isClosed = false;
              } else if (closingtime < date.hour) {
                isClosed = true;
                opeingText = "Opens " +
                    twlevehourtime(int.parse(mnjson["Data"]["Seller"][0]
                            ["mondayopeningtime"]
                        .toString()
                        .split(':')[0])) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["mondayopeningtime"]
                        .toString()
                        .split(':')[1];
                " Mon";
              }
            }
          } else if (day == "Monday") {
            if (mnjson["Data"]["Seller"][0].containsKey("mondayopeningtime")) {
              int openingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["mondayopeningtime"]
                  .toString()
                  .split(':')[0]);
              int closingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["mondayclosingtime"]
                  .toString()
                  .split(':')[0]);

              if (openingtime <= date.hour && closingtime > date.hour) {
                opeingText = "Open . Closes " +
                    twlevehourtime(closingtime) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["mondayclosingtime"]
                        .toString()
                        .split(':')[1];
                isClosed = false;
              } else if (closingtime < date.hour) {
                isClosed = true;
                opeingText = "Opens " +
                    twlevehourtime(int.parse(mnjson["Data"]["Seller"][0]
                            ["tuesdayopeningtime"]
                        .toString()
                        .split(':')[0])) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["tuesdayopeningtime"]
                        .toString()
                        .split(':')[1];
                " Tue";
              }
            }
          } else if (day == "Tuesday") {
            if (mnjson["Data"]["Seller"][0].containsKey("tuesdayopeningtime")) {
              int openingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["tuesdayopeningtime"]
                  .toString()
                  .split(':')[0]);
              int closingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["tuesdayclosingtime"]
                  .toString()
                  .split(':')[0]);

              if (openingtime <= date.hour && closingtime > date.hour) {
                opeingText = "Open . Closes " +
                    twlevehourtime(closingtime) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["tuesdayclosingtime"]
                        .toString()
                        .split(':')[1];
                isClosed = false;
              } else if (closingtime < date.hour) {
                isClosed = true;
                opeingText = "Opens " +
                    twlevehourtime(int.parse(mnjson["Data"]["Seller"][0]
                            ["wednesdayopeningtime"]
                        .toString()
                        .split(':')[0])) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["wednesdayopeningtime"]
                        .toString()
                        .split(':')[1];
                " Wed";
              }
            }
          } else if (day == "Wednesday") {
            if (mnjson["Data"]["Seller"][0]
                .containsKey("wednesdayopeningtime")) {
              int openingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["wednesdayopeningtime"]
                  .toString()
                  .split(':')[0]);
              int closingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["wednesdayclosingtime"]
                  .toString()
                  .split(':')[0]);

              if (openingtime <= date.hour && closingtime > date.hour) {
                opeingText = "Open . Closes " +
                    twlevehourtime(closingtime) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["wednesdayclosingtime"]
                        .toString()
                        .split(':')[1];
                isClosed = false;
              } else if (closingtime < date.hour) {
                isClosed = true;
                opeingText = "Opens " +
                    twlevehourtime(int.parse(mnjson["Data"]["Seller"][0]
                            ["tuesdayopeningtime"]
                        .toString()
                        .split(':')[0])) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["tuesdayopeningtime"]
                        .toString()
                        .split(':')[1];
                " Thu";
              }
            }
          } else if (day == "Thursday") {
            if (mnjson["Data"]["Seller"][0]
                .containsKey("thursdayopeningtime")) {
              int openingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["thursdayopeningtime"]
                  .toString()
                  .split(':')[0]);
              int closingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["tuesdayclosingtime"]
                  .toString()
                  .split(':')[0]);

              if (openingtime <= date.hour && closingtime > date.hour) {
                opeingText = "Open . Closes " +
                    twlevehourtime(closingtime) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["tuesdayclosingtime"]
                        .toString()
                        .split(':')[1];
                isClosed = false;
              } else if (closingtime < date.hour) {
                isClosed = true;
                opeingText = "Opens " +
                    twlevehourtime(int.parse(mnjson["Data"]["Seller"][0]
                            ["fridayopeningtime"]
                        .toString()
                        .split(':')[0])) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["fridayopeningtime"]
                        .toString()
                        .split(':')[1];
                " Fri";
              }
            }
          } else if (day == "Friday") {
            if (mnjson["Data"]["Seller"][0].containsKey("fridayopeningtime")) {
              int openingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["fridayopeningtime"]
                  .toString()
                  .split(':')[0]);
              int closingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["fridayclosingtime"]
                  .toString()
                  .split(':')[0]);

              if (openingtime <= date.hour && closingtime > date.hour) {
                opeingText = "Open . Closes " +
                    twlevehourtime(closingtime) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["fridayclosingtime"]
                        .toString()
                        .split(':')[1];
                isClosed = false;
              } else if (closingtime < date.hour) {
                isClosed = true;
                opeingText = "Opens " +
                    twlevehourtime(int.parse(mnjson["Data"]["Seller"][0]
                            ["saturdayopeningtime"]
                        .toString()
                        .split(':')[0])) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["saturdayopeningtime"]
                        .toString()
                        .split(':')[1];
                " Sat";
              }
            }
          } else if (day == "Saturday") {
            if (mnjson["Data"]["Seller"][0]
                .containsKey("saturdayopeningtime")) {
              print("345678904567890-4567890-=567890-=7890-");
              int openingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["saturdayopeningtime"]
                  .toString()
                  .split(':')[0]);
              int closingtime = int.parse(mnjson["Data"]["Seller"][0]
                      ["saturdayclosingtime"]
                  .toString()
                  .split(':')[0]);

              if (openingtime <= date.hour && closingtime > date.hour) {
                opeingText = "Open . Closes " +
                    twlevehourtime(closingtime) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["saturdayclosingtime"]
                        .toString()
                        .split(':')[1];
                isClosed = false;
              } else if (closingtime < date.hour) {
                opeingText = "Opens " +
                    twlevehourtime(int.parse(mnjson["Data"]["Seller"][0]
                            ["sundayopeningtime"]
                        .toString()
                        .split(':')[0])) +
                    ":" +
                    mnjson["Data"]["Seller"][0]["sundayopeningtime"]
                        .toString()
                        .split(':')[1];
                " Sun";
                isClosed = true;
              }
            }
          }
          setState(() {});
          print("34567890erty890- 567890-=rtyuiop[]");
          print(opeingText);
        }
      }
    });
  }

  void applyRatting() async {}
  void getCatelouges() async {
    setState(() {
      catelouges = [];
    });
    var nencoded = Uri.parse(get_catelogues + categoryId);
    // var nencoded = Uri.parse(get_catelogues + categoryId!);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mjson;
        mjson = json.decode(resp.body);
        for (int i = 0; i < mjson["data"]["catlog"].length; i++) {
          bool isExists = false;
          var coded = Uri.parse(getSubcategoriesByCatelogid +
              mjson["data"]["catlog"][i]["_id"].toString());

          http.get(coded).then((value) {
            if (value.statusCode == 200) {
              Map mnjson;
              mnjson = json.decode(value.body);
              for (int k = 0; k < mnjson["data"]["catlog"].length; k++) {
                for (int l = 0; l < products.length; l++) {
                  if (mnjson["data"]["catlog"][k]["_id"].toString() ==
                          products[l]["catalogueid"].toString() &&
                      isExists == false) {
                    isExists = true;
                    setState(() {
                      catelouges.add(mjson["data"]["catlog"][i]);
                    });
                    //break;
                  }
                }
              }
            }
          });
        }
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
        getCatelouges();
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

  void addView() {
    var nencoded = Uri.parse(postview);
    print("sssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
    http.post(nencoded, body: {
      "cid": widget.userid,
      "userid": widget.userid,
      "type": "store"
    }).then((value) {
      print("-----------------------------");
      print(value.statusCode);
      if (value.statusCode == 200) {}
    });
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
    addView();
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
              minHeight: 260,
              maxHeight: 260,
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
                          Expanded(
                            child: Text(
                              storename,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(70.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Status()));
                                },
                                child: Image.network(
                                  baseUrl + imageUrl,
                                  fit: BoxFit.cover,
                                ),
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
                        SizedBox(width: 10),
                        Expanded(
                            child: isClosed == true
                                ? Row(
                                    children: [
                                      Text(
                                        "Closed",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      Text(opeingText)
                                    ],
                                  )
                                : Text(opeingText))
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
              minHeight: 92,
              maxHeight: 92,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: catelouges.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubCategoryScreen(
                                      catelouges[index]["_id"],
                                      categoryId,
                                      catelouges,
                                      widget.userid)));
                        },
                        child: Container(
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SubCategoryScreen(
                                                      catelouges[index]["_id"],
                                                      categoryId,
                                                      catelouges,
                                                      widget.userid)));
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
                        ),
                      );
                    }),
              ),
            )),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
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
                                "63% Off",
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

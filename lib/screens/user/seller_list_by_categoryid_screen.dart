import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:oim/screens/user/resturent_details_screen.dart';
import 'package:oim/screens/user/store_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerListByCategoryIdScreen extends StatefulWidget {
  final String categoryid, catrgoryName;
  SellerListByCategoryIdScreen(this.categoryid, this.catrgoryName);

  @override
  State<SellerListByCategoryIdScreen> createState() =>
      _SellerListByCategoryIdScreenState();
}

class _SellerListByCategoryIdScreenState
    extends State<SellerListByCategoryIdScreen> {
  List sellers = [];
  getStores() async {
    var encoded = Uri.parse(get_seller_and_products + "/d");
    print(get_seller_and_products + "/" + widget.categoryid);
    http.get(encoded).then((value) async {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson["data"]["result"]);
        setState(() {
          sellers = mjson["data"]["seller"];
        });
      }
    }).catchError((onError) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catrgoryName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: sellers.length,
                  itemBuilder: (context, index) {
                    return sellers[index]["businesscatagories"] ==
                            widget.categoryid
                        ? Column(
                            children: [
                              sellers[index]["products"].length > 0
                                  ? Container(
                                      height: 210,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              sellers[index]["products"].length,
                                          itemBuilder: (context, iindex) {
                                            double disount = double.parse(
                                                    sellers[index]["products"]
                                                            [iindex]["mrp"]
                                                        .toString()) -
                                                double.parse(sellers[index]
                                                            ["products"][iindex]
                                                        ["sellingprice"]
                                                    .toString());
                                            double discountPercentage =
                                                (disount /
                                                        double.parse(sellers[
                                                                        index]
                                                                    ["products"]
                                                                [iindex]["mrp"]
                                                            .toString())) *
                                                    100;
                                            return sellers[index]["products"]
                                                                [iindex]
                                                            ["instock"] ==
                                                        true &&
                                                    sellers[index]["products"]
                                                                [iindex]
                                                            ["isdeleted"] ==
                                                        false
                                                ? InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProductDetailsScreen(sellers[index]
                                                                              [
                                                                              "products"][iindex]
                                                                          [
                                                                          "_id"]
                                                                      .toString())));
                                                    },
                                                    child: SizedBox(
                                                      child: SizedBox(
                                                        height: 210,
                                                        width: 160,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 2,
                                                                      bottom:
                                                                          12),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                child: SizedBox(
                                                                  height: 150,
                                                                  width: 150,
                                                                  child: Image
                                                                      .network(
                                                                    baseUrl +
                                                                        sellers[index]["products"][iindex]["image"][0]
                                                                            [
                                                                            "filename"],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            2),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          sellers[index]["products"][iindex]
                                                                              [
                                                                              "productname"],
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 4.0,
                                                                              bottom: 4),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                '\₹${sellers[index]["products"][iindex]["mrp"]}',
                                                                                style: TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough),
                                                                              ),
                                                                              Text(
                                                                                '    \₹${sellers[index]["products"][iindex]["sellingprice"]}',
                                                                                style: TextStyle(fontSize: 13, color: Colors.black),
                                                                              ),
                                                                              Text(
                                                                                '  ${discountPercentage.toStringAsFixed(0)}% off',
                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox();
                                          }),
                                    )
                                  : SizedBox(),
                              sellerwidget(index)
                            ],
                          )
                        : SizedBox();
                  }))
        ],
      ),
    );
  }

  Widget sellerwidget(int index) {
    double ratting = 0;
    int noofrattings = 0;
    double appliedRatting = 0;
    double oneStar = 0;
    double twoStar = 0;
    double threeStar = 0;
    double fourStar = 0;
    double fiveStar = 0;
    double total = 0;
    for (int i = 0; i < sellers[index]["rattings"].length; i++) {
      if (sellers[index]["userid"].toString() ==
          sellers[index]["rattings"][i]["storeid"].toString()) {
        noofrattings = noofrattings + 1;
        total = total +
            double.parse(
                sellers[index]["rattings"][i]["applied_ratting"].toString());
      }
    }
    if (total > 0) {
      ratting = total / noofrattings;

      if (ratting < 1) {
        ratting = 0.5;
      } else if (ratting < 1.5) {
        ratting = 1;
      } else if (ratting < 2) {
        ratting = 1.5;
      } else if (ratting < 2.5) {
        ratting = 2;
      } else if (ratting < 3) {
        ratting = 2.5;
      } else if (ratting < 3.5) {
        ratting = 3;
      } else if (ratting < 4) {
        ratting = 3.5;
      } else if (ratting < 4.5) {
        ratting = 4;
      } else if (ratting < 5) {
        ratting = 4.5;
      } else {
        ratting = 5;
      }
    }
    DateTime date = DateTime.now();

    String day = DateFormat('EEEE').format(date);
    String opeingText = "";
    bool isClosed = false;
    if (day == "Sunday") {
      if (sellers[index].containsKey("sundayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["sundayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["sundayclosingtime"].toString().split(':')[0]);
        if (openingtime <= date.hour && closingtime > date.hour) {
          opeingText =
              "Open . Closes " + sellers[index]["sundayclosingtime"].toString();
          isClosed = false;
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              sellers[index]["mondayopeningtime"].toString() +
              " Mon";
        }
      }
    } else if (day == "Monday") {
      if (sellers[index].containsKey("mondayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["mondayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["mondayclosingtime"].toString().split(':')[0]);
        if (openingtime <= date.hour && closingtime > date.hour) {
          isClosed = false;
          opeingText =
              "Open . Closes " + sellers[index]["mondayclosingtime"].toString();
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              sellers[index]["tuesdayopeningtime"].toString() +
              " Tue";
        }
      }
    } else if (day == "Tuesday") {
      if (sellers[index].containsKey("tuesdayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["tuesdayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["tuesdayclosingtime"].toString().split(':')[0]);

        if (openingtime <= date.hour && closingtime > date.hour) {
          isClosed = false;
          opeingText = "Open . Closes " +
              sellers[index]["tuesdayclosingtime"].toString();
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              sellers[index]["wednesdayopeningtime"].toString() +
              " Wed";
        }
      }
    } else if (day == "Wednesday") {
      if (sellers[index].containsKey("wednesdayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["wednesdayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["wednesdayclosingtime"].toString().split(':')[0]);

        if (openingtime <= date.hour && closingtime > date.hour) {
          isClosed = false;
          opeingText = "Open . Closes " +
              sellers[index]["wednesdayclosingtime"].toString();
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              sellers[index]["tuesdayopeningtime"].toString() +
              " Thu";
        }
      }
    } else if (day == "Thursday") {
      if (sellers[index].containsKey("thursdayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["thursdayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["tuesdayclosingtime"].toString().split(':')[0]);
        if (openingtime <= date.hour && closingtime > date.hour) {
          isClosed = false;
          opeingText = "Open . Closes " +
              sellers[index]["tuesdayclosingtime"].toString();
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              sellers[index]["fridayopeningtime"].toString() +
              " Fri";
        }
      }
    } else if (day == "Friday") {
      if (sellers[index].containsKey("fridayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["fridayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["fridayclosingtime"].toString().split(':')[0]);

        if (openingtime <= date.hour && closingtime > date.hour) {
          isClosed = false;
          opeingText =
              "Open . Closes " + sellers[index]["fridayclosingtime"].toString();
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              sellers[index]["saturdayopeningtime"].toString() +
              " Sat";
        }
      }
    } else if (day == "Saturday") {
      if (sellers[index].containsKey("saturdayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["saturdayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["saturdayclosingtime"].toString().split(':')[0]);

        if (openingtime <= date.hour && closingtime > date.hour) {
          isClosed = false;
          opeingText = "Open . Closes " +
              sellers[index]["saturdayclosingtime"].toString();
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              sellers[index]["sundayopeningtime"].toString() +
              " Sun";
        }
      }
    }
    return InkWell(
      onTap: () {
        sellers[index]["businesscatagories"] == "Restaurant"
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ResturentDetailsScreen(sellers[index]["userid"])))
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StoreDetailsScreen(sellers[index]["userid"])));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sellers[index]["businessname"],
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(ratting.toString()),
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
                      Text("(" + noofrattings.toString() + ")")
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                    child: Text(
                      sellers[index]["streetaddress"],
                    ),
                  ),
                  Text("In-store shopping"),
                  isClosed == true
                      ? Row(
                          children: [
                            Text(
                              "Closed",
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(opeingText)
                          ],
                        )
                      : Text(opeingText)
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                    child: SizedBox(
                      width: 60,
                      child: Row(
                        children: [
                          Icon(
                            Icons.call,
                            color: Colors.blue,
                          ),
                          Text(
                            '  Call',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    onPressed: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: sellers[index]["businesscontactinfo"],
                      );
                      await launchUrl(launchUri);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15.0),
                  child: RaisedButton(
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions,
                            color: Colors.blue,
                          ),
                          Text(
                            '  Directions',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    onPressed: () async {
                      String googleUrl =
                          'https://www.google.com/maps/search/?api=1&query=${sellers[index]["latitude"]},${sellers[index]["longitude"]}';

                      print(googleUrl);

                      await launch(googleUrl);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15.0),
                  child: RaisedButton(
                    child: SizedBox(
                      width: 70,
                      child: Row(
                        children: [
                          Icon(
                            Icons.share,
                            color: Colors.blue,
                          ),
                          Text(
                            '  Share',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 20, bottom: 10),
                child: Divider(
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreRattingScreen extends StatefulWidget {
  final String storeid, storename, storeaddress, storeLogo;
  StoreRattingScreen(
      this.storeid, this.storename, this.storeaddress, this.storeLogo);

  @override
  State<StoreRattingScreen> createState() => _StoreRattingScreenState();
}

class _StoreRattingScreenState extends State<StoreRattingScreen> {
  double ratting = 0;
  int noofrattings = 0;
  double appliedRatting = 0;
  double oneStar = 0;
  double twoStar = 0;
  double threeStar = 0;
  double fourStar = 0;
  double fiveStar = 0;
  void getappliedRatting() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var encoded = Uri.parse(get_appliedrattings +
        preferences.getString("userid").toString() +
        "/" +
        widget.storeid);
    print("zeeeeeerrr7777777777777777777777");

    print(get_appliedrattings +
        preferences.getString("userid").toString() +
        "/" +
        widget.storeid);
    print("zeeeeeerrr7777777777777777777777");
    http.get(encoded).then((value) {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson);

        setState(() {
          appliedRatting = double.parse(
              mjson["data"]["storeratting"][0]["applied_ratting"].toString());
        });
      }
    });
  }

  void getRattings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var encoded = Uri.parse(get_rattings + widget.storeid);
    print("##########################zeeeeeerrr7777777777777777777777");

    print(get_rattings + widget.storeid);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //exit(0);
    getappliedRatting();
    getRattings();
  }

  void appliRatting() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var encoded = Uri.parse(apply_ratting);
    http.post(encoded,
        body: jsonEncode({
          "userid": preferences.getString("userid"),
          "storeid": widget.storeid,
          "applied_ratting": appliedRatting
        }),
        headers: {"content-type": "application/json"}).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storename),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.storename,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(children: [
              Text(
                ratting.toStringAsFixed(2),
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 11.0),
                child: RatingBar(
                  ignoreGestures: true,
                  itemSize: 20,
                  allowHalfRating: true,
                  initialRating: ratting,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  ratingWidget: RatingWidget(
                    empty:
                        Icon(Icons.star_border, color: primaryColor, size: 20),
                    full: Icon(
                      Icons.star,
                      color: primaryColor,
                      size: 20,
                    ),
                    half: Icon(Icons.star_half, color: primaryColor, size: 20),
                  ),
                  onRatingUpdate: (value) {
                    print(value);
                  },
                ),
              ),
              Text("(" + noofrattings.toString() + ")"),
            ]),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(widget.storeaddress),
                Text(
                  "Open",
                  style: TextStyle(color: primaryColor),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 70,
              width: 70,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: InkWell(
                  onTap: () {},
                  child: Image.network(
                    baseUrl + widget.storeLogo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text("Rate and review"),
            SizedBox(
              height: 10,
            ),
            Text("Share your exprieance to help others."),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 11.0),
              child: RatingBar.builder(
                initialRating: appliedRatting,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: primaryColor,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    appliedRatting = rating;
                  });
                  appliRatting();
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _ratingAndReviews()
          ],
        ),
      )),
    );
  }

  _ratingAndReviews() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      //color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 0),
            child: Center(
              child: Text(
                'Ratings',
                style: black16BoldTextStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '5',
                          ),
                        ),
                        new LinearPercentIndicator(
                          width: 140.0,
                          lineHeight: 8.0,
                          percent: (fiveStar / noofrattings),
                          backgroundColor: Colors.grey[200],
                          progressColor: primaryColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '4',
                          ),
                        ),
                        new LinearPercentIndicator(
                          width: 140.0,
                          lineHeight: 8.0,
                          percent: (fourStar / noofrattings),
                          backgroundColor: Colors.grey[200],
                          progressColor: primaryColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '3',
                          ),
                        ),
                        new LinearPercentIndicator(
                          width: 140.0,
                          lineHeight: 8.0,
                          percent: (threeStar / noofrattings),
                          backgroundColor: Colors.grey[200],
                          progressColor: primaryColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '2',
                          ),
                        ),
                        new LinearPercentIndicator(
                          width: 140.0,
                          lineHeight: 8.0,
                          percent: (twoStar / noofrattings),
                          backgroundColor: Colors.grey[200],
                          progressColor: primaryColor,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '1',
                          ),
                        ),
                        new LinearPercentIndicator(
                          width: 140.0,
                          lineHeight: 8.0,
                          percent: (oneStar / noofrattings),
                          backgroundColor: Colors.grey[200],
                          progressColor: primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 11.0),
                      child: Text(
                        ratting.toStringAsFixed(2),
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 11.0),
                      child: RatingBar(
                        ignoreGestures: true,
                        itemSize: 13,
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
                        onRatingUpdate: (value) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 11.0, top: 11),
                      child: Text(
                        noofrattings.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

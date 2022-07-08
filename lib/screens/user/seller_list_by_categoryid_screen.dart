import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/product_details_screen.dart';
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
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sellers[index]["businessname"],
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Text("0"),
                                              Icon(
                                                Icons.star,
                                                color: Colors.green,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.green,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.green,
                                              ),
                                              Icon(Icons.star,
                                                  color: Colors.grey[500]),
                                              Icon(Icons.star,
                                                  color: Colors.grey[500]),
                                              Text("15.5 km")
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4.0, bottom: 4),
                                            child: Text(
                                              sellers[index]["streetaddress"],
                                            ),
                                          ),
                                          Text("In-store shopping")
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
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
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16.0))),
                                            onPressed: () async {
                                              final Uri launchUri = Uri(
                                                scheme: 'tel',
                                                path: sellers[index]
                                                    ["businesscontactinfo"],
                                              );
                                              await launchUrl(launchUri);
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 15.0),
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
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16.0))),
                                            onPressed: () async {
                                              String googleUrl =
                                                  'https://www.google.com/maps/search/?api=1&query=${sellers[index]["latitude"]},${sellers[index]["longitude"]}';

                                              print(googleUrl);

                                              await launch(googleUrl);
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 15.0),
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
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16.0))),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            left: 10,
                                            right: 20,
                                            bottom: 10),
                                        child: Divider(
                                          color: Colors.grey,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : SizedBox();
                  }))
        ],
      ),
    );
  }
}

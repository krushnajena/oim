import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/add_business_hour.dart';
import 'package:oim/screens/seller/select_product_for_add_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostAdScreen extends StatefulWidget {
  const PostAdScreen({Key? key}) : super(key: key);

  @override
  State<PostAdScreen> createState() => _PostAdScreenState();
}

class _PostAdScreenState extends State<PostAdScreen> {
  bool isSwitched = false;
  int noOfAds = 0;
  int totalAds = 0;
  int usedAds = 0;
  List ads = [];

  void getTotalNoOfAds() async {
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
        setState(() {
          totalAds = mnjson["data"]["addpackage"][0]["noofads"];
        });
        getNoOfUsedAds();
      }
    });
  }

  void getNoOfUsedAds() async {
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
      }
    });
  }

  void getAds() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString("userid").toString();
    print(userid);
    var nencoded = Uri.parse(get_adds_by_sellerid + userid);
    print(get_adds_by_sellerid + userid);
    http.get(nencoded).then((value) {
      if (value.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(value.body);
        print(value.body);
        setState(() {
          ads = mnjson["data"]["result"];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAds();
    getTotalNoOfAds();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          title: Text("Ads Balance-" + noOfAds.toString()),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            var a = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectProductForAdScreen()));
            getTotalNoOfAds();
          },
          isExtended: true,
          backgroundColor: Colors.orange[800],
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: Text(
            "Select Product",
            style: TextStyle(fontSize: 19, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 1.5,
            ),
            Container(
              height: 55,
              color: Colors.blue,
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    "Total Ads-" + totalAds.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  VerticalDivider(
                    color: Colors.white,
                    thickness: 1.5,
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Text("Used Ads-" + usedAds.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18)),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
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
                                          height: 100,
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  16) /
                                              2,
                                          child: Image.network(
                                            baseUrl +
                                                ads[index]["productid"]["image"]
                                                    [0]["filename"],
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
                                      ads[index]["productid"]["productname"],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 3,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                            "₹" +
                                                ads[index]["productid"]["mrp"]
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                                decoration: TextDecoration
                                                    .lineThrough)),
                                        SizedBox(width: 5),
                                        Text(
                                            "₹" +
                                                ads[index]["productid"]
                                                        ["sellingprice"]
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(width: 5),
                                        Text(
                                          "26%",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          ads[index]["productid"]["instock"]
                                              ? "In Stock"
                                              : "Stock Out",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: ads[index]["productid"]
                                                      ["instock"]
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.remove_red_eye_outlined,
                                              size: 10,
                                            ),
                                            Text(
                                                "  Views : " +
                                                    ads[index]["productid"]
                                                            ["views"]
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Center(
                                          child: OutlineButton(
                                              onPressed: () {},
                                              child: const Text("Delete Ad",
                                                  style:
                                                      TextStyle(fontSize: 12))),
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
                      childCount: ads.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      mainAxisExtent: 283,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

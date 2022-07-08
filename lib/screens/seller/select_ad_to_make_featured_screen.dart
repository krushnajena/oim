import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/ad_plans_screen.dart';
import 'package:oim/screens/seller/featured_ad_package.dart';
import 'package:oim/screens/seller/post_add_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SelectAdToMakeFeaturedScreen extends StatefulWidget {
  const SelectAdToMakeFeaturedScreen({Key? key}) : super(key: key);

  @override
  State<SelectAdToMakeFeaturedScreen> createState() =>
      _SelectAdToMakeFeaturedScreenState();
}

class _SelectAdToMakeFeaturedScreenState
    extends State<SelectAdToMakeFeaturedScreen> {
  List ads = [];
  bool isloaded = false;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show your ads on top"),
        centerTitle: true,
      ),
      body: ads.length > 0
          ? CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ads[index]["adtype"] == "normal"
                          ? Container(
                              height: 250,
                              child: Card(
                                child: Container(
                                  height: 250,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    ads[index]["productid"]
                                                            ["image"][0]
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
                                                      BorderRadius.circular(
                                                          150),
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          ads[index]["productid"]
                                              ["productname"],
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
                                                    ads[index]["productid"]
                                                            ["mrp"]
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
                                                    fontWeight:
                                                        FontWeight.w500)),
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
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FeaturedAdPackages()));
                                                  },
                                                  child: const Text(
                                                      "Make this Ad Featured",
                                                      style: TextStyle(
                                                          fontSize: 12))),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox();
                    },
                    childCount: ads.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 283,
                  ),
                ),
              ],
            )
          : Center(
              child: SizedBox(),
            ),
    );
  }
}

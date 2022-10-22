import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double Mrptotal = 0;
  double sellingtotal = 0;
  bool isLoaded = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartItems();
  }

  List items = [];
  void getCartItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(get_cart_or_wishlist_items +
        preferences.getString("userid").toString() +
        "/cart");

    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        print(mnjson["data"]["result"]);

        setState(() {
          items = mnjson["data"]["result"];
        });
        double mrp = 0;
        double s = 0;
        for (int i = 0; i < mnjson["data"]["result"].length; i++) {
          mrp = mrp +
              double.parse(
                  mnjson["data"]["result"][i]["productid"]["mrp"].toString());
          s = s +
              double.parse(mnjson["data"]["result"][i]["productid"]
                      ["sellingprice"]
                  .toString());
        }
        setState(() {
          Mrptotal = mrp;
          sellingtotal = s;
          isLoaded = true;
        });
      }
    });
  }

  void getRemoveItem(String _id) async {
    var nencoded = Uri.parse(get_removeItem + _id);

    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        print(mnjson);
        getCartItems();
        showInSnackBar("Item Removed From Cart");
      }
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return items.length > 0 && isLoaded == true
        ? Scaffold(
            backgroundColor: Colors.blue,
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.blue,
                    expandedHeight: deviceHeight * 0.15,
                    elevation: 0,
                    pinned: true,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Cart',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  items.length.toString() + ' items',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                                Text(
                                  "₹" +
                                      "${sellingtotal.toStringAsFixed(2).toString()}",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Container(
                          height: deviceHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(45),
                                topRight: Radius.circular(45)),
                            color: Colors.grey.shade100,
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 45, left: 15, right: 15),
                            child: items.length > 0
                                ? ListView.builder(
                                    itemCount: items.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      double disount = double.parse(items[index]
                                                  ["productid"]["mrp"]
                                              .toString()) -
                                          double.parse(items[index]["productid"]
                                                  ["sellingprice"]
                                              .toString());
                                      double discountPercentage = (disount /
                                              double.parse(items[index]
                                                      ["productid"]["mrp"]
                                                  .toString())) *
                                          100;
                                      return Column(
                                        children: [
                                          Container(
                                              height: deviceHeight * 0.17,
                                              decoration: BoxDecoration(
                                                color: Colors.black12
                                                    .withOpacity(0.09),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetailsScreen(
                                                                  items[index][
                                                                              "productid"]
                                                                          [
                                                                          "_id"]
                                                                      .toString())));
                                                },
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              top: 15.0,
                                                              bottom: 15.0),
                                                      child: SizedBox(
                                                        height: 70,
                                                        width: 70,
                                                        child: Container(
                                                          height: 150,
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image:
                                                                        NetworkImage(
                                                                      baseUrl +
                                                                          items[index]["productid"]["image"][0]
                                                                              [
                                                                              "filename"],
                                                                    )),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8.0)),
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            items[index][
                                                                    "productid"]
                                                                ["productname"],
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          //SizedBox(height: deviceHeight * 0.005),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "₹" +
                                                                    items[index]["productid"]
                                                                            [
                                                                            "mrp"]
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough),
                                                              ),
                                                              SizedBox(
                                                                  width: 10),
                                                              Text(
                                                                "₹" +
                                                                    items[index]["productid"]
                                                                            [
                                                                            "sellingprice"]
                                                                        .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                discountPercentage
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    "% off",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .green
                                                                        .shade500),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 15),
                                                          Text(
                                                            items[index]
                                                                ["sellername"],
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            items[index][
                                                                "sellerlocation"],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          //SizedBox(height: 20),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 0),
                                                          height: 125,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=' +
                                                                      items[index]
                                                                              [
                                                                              "sellerlat"]
                                                                          .toString() +
                                                                      ',' +
                                                                      items[index]
                                                                              [
                                                                              "sellerlang"]
                                                                          .toString();

                                                                  print(
                                                                      googleUrl);
                                                                  await launch(
                                                                      googleUrl);
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .location_on_rounded,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  getRemoveItem(
                                                                      items[index]
                                                                              [
                                                                              "_id"]
                                                                          .toString());
                                                                },
                                                                icon: Icon(
                                                                  Icons.delete,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )),
                                          SizedBox(
                                            height: deviceHeight * 0.01,
                                          )
                                        ],
                                      );
                                    })
                                : Center(
                                    child: Image(
                                      image:
                                          AssetImage("images/emptycart.jpeg"),
                                      height: 200,
                                    ),
                                  ),
                          )))
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Cart"),
              centerTitle: true,
            ),
            body: Center(
                child: Image(
              image: AssetImage("images/emptycart.png"),
            )),
          );
  }
}

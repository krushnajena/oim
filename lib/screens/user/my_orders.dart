import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MyOrders extends StatefulWidget {
  MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  double Mrptotal = 0;
  double sellingtotal = 0;
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
    return Scaffold(
      backgroundColor: Colors.amber,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'My',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Text(
                          'Cart',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
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
            backgroundColor: Colors.amber,
            expandedHeight: 160,
            leading: Icon(Icons.arrow_back),
          ),
          SliverToBoxAdapter(
              child: Container(
                  height: 950,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.grey.shade100,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 45, left: 30, right: 30),
                    child: ListView.builder(
                        itemCount: items.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          double disount = double.parse(
                                  items[index]["productid"]["mrp"].toString()) -
                              double.parse(items[index]["productid"]
                                      ["sellingprice"]
                                  .toString());
                          double discountPercentage = (disount /
                                  double.parse(items[index]["productid"]["mrp"]
                                      .toString())) *
                              100;
                          return Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsScreen(items[index]
                                                      ["productid"]["_id"]
                                                  .toString())));
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 15, bottom: 15),
                                      child: SizedBox(
                                        height: 85,
                                        width: 85,
                                        child: ClipRRect(
                                          child: Image.network(
                                            baseUrl +
                                                items[index]["productid"]
                                                    ["image"][0]["filename"],
                                            fit: BoxFit.fill,
                                            width: 90,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            items[index]["productid"]
                                                ["productname"],
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "₹" +
                                                    items[index]["productid"]
                                                            ["mrp"]
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "₹" +
                                                    items[index]["productid"]
                                                            ["sellingprice"]
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                discountPercentage
                                                        .toStringAsFixed(2) +
                                                    "% Off",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            items[index]["sellername"],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black26),
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on_outlined),
                                              Text(
                                                items[index]["sellerlocation"],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                          child: Column(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  String googleUrl =
                                                      'https://www.google.com/maps/search/?api=1&query=' +
                                                          items[index]
                                                                  ["sellerlat"]
                                                              .toString() +
                                                          ',' +
                                                          items[index]
                                                                  ["sellerlang"]
                                                              .toString();

                                                  print(googleUrl);

                                                  await launch(googleUrl);
                                                },
                                                icon: Icon(
                                                  Icons.location_on_outlined,
                                                  size: 16,
                                                ),
                                              ),
                                              SizedBox(height: 3.5),
                                              SizedBox(height: 3.5),
                                              IconButton(
                                                onPressed: () {
                                                  getRemoveItem(items[index]
                                                          ["_id"]
                                                      .toString());
                                                },
                                                icon: Icon(
                                                  Icons.minimize,
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ));
                        }),
                  )))
        ],
      ),
    );
  }
}

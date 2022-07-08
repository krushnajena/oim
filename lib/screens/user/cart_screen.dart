import 'dart:convert';

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
      appBar: AppBar(
        title: Text("Cart"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: items.length > 0
            ? Column(
                children: [
                  ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      double disount = double.parse(
                              items[index]["productid"]["mrp"].toString()) -
                          double.parse(items[index]["productid"]["sellingprice"]
                              .toString());
                      double discountPercentage = (disount /
                              double.parse(items[index]["productid"]["mrp"]
                                  .toString())) *
                          100;

                      return Stack(children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                        items[index]["productid"]["_id"]
                                            .toString())));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 20, left: 20),
                              height: 150,
                              width: 350,
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: SizedBox(
                                              height: 85,
                                              width: 85,
                                              child: Image.network(
                                                baseUrl +
                                                    items[index]["productid"]
                                                            ["image"][0]
                                                        ["filename"],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                items[index]["productid"]
                                                    ["productname"],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text(
                                                    "₹" +
                                                        items[index][
                                                                    "productid"]
                                                                ["sellingprice"]
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black26),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "₹" +
                                                        items[index][
                                                                    "productid"]
                                                                ["mrp"]
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black26,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    discountPercentage
                                                            .toStringAsFixed(
                                                                2) +
                                                        "% Off",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.green),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                items[index]["sellername"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black26),
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(Icons
                                                      .location_on_outlined),
                                                  Text(
                                                    items[index]
                                                        ["sellerlocation"],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 125,
                            left: 23,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 172,
                                child: OutlinedButton(
                                  onPressed: () {
                                    getRemoveItem(
                                        items[index]["_id"].toString());
                                  },
                                  child: Text(
                                    "REMOVE",
                                    style: TextStyle(color: Colors.black38),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 172,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    String googleUrl =
                                        'https://www.google.com/maps/search/?api=1&query=' +
                                            items[index]["sellerlat"]
                                                .toString() +
                                            ',' +
                                            items[index]["sellerlang"]
                                                .toString();

                                    print(googleUrl);

                                    await launch(googleUrl);
                                  },
                                  child: Text("DIRECTIONS",
                                      style: TextStyle(color: Colors.black38)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 19),
                    height: 200,
                    width: 370,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 5),
                          child: Text(
                            "PRICE DETAILS",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black26,
                                fontSize: 16),
                          ),
                        ),
                        Divider(
                          color: Colors.black38,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 5),
                          child: Row(
                            children: [
                              Text(
                                "Price (" + items.length.toString() + " items)",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: 14),
                              ),
                              SizedBox(
                                width: 195,
                              ),
                              Text(
                                "₹" + Mrptotal.toStringAsFixed(2),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 5),
                          child: Row(
                            children: [
                              Text(
                                "Discount",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: 14),
                              ),
                              SizedBox(width: 195),
                              Text(
                                "-₹" +
                                    (Mrptotal - sellingtotal)
                                        .toStringAsFixed(2),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -',
                          style: TextStyle(color: Colors.black38),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, bottom: 5, top: 5),
                          child: Row(
                            children: [
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    fontSize: 14),
                              ),
                              SizedBox(width: 195),
                              Text(
                                "₹" + sellingtotal.toStringAsFixed(2),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black38,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                              "You will save ₹" +
                                  (Mrptotal - sellingtotal).toStringAsFixed(2) +
                                  " on this order",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                  fontSize: 14)),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  children: [
                    Image(
                        image: AssetImage(
                      "images/emptycart.png",
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Back To Home"),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

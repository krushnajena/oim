import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  double Mrptotal = 0;
  double sellingtotal = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartItems();
  }

  List products = [];
  void getCartItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(get_cart_or_wishlist_items +
        preferences.getString("userid").toString() +
        "/wishlist");

    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        print(mnjson["data"]["result"]);
        setState(() {
          products = mnjson["data"]["result"];
        });
        if (mnjson["data"]["result"].length > 0) {
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

  void moveToCart(String _id) async {
    var nencoded = Uri.parse(get_movetocart + _id);

    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        print(mnjson);
        getCartItems();
        showInSnackBar("Item Moved To Cart");
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
        title: Text("Wishlist"),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                double disount = double.parse(
                        products[index]["productid"]["mrp"].toString()) -
                    double.parse(products[index]["productid"]["sellingprice"]
                        .toString());
                double discountPercentage = (disount /
                        double.parse(
                            products[index]["productid"]["mrp"].toString())) *
                    100;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                                products[index]["productid"]["_id"]
                                    .toString())));
                  },
                  child: SizedBox(
                    height: 200,
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
                                        products[index]["productid"]["image"][0]
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
                                  products[index]["productid"]["sellingprice"]
                                      .toString(),
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹" +
                                  products[index]["productid"]["mrp"]
                                      .toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            Text(
                              discountPercentage.toStringAsFixed(2) + "% Off",
                              style: TextStyle(color: Colors.green),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  products[index]["productid"]["productname"]),
                            )),
                            PopupMenuButton(
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: Text("Move to cart"),
                                        value: 1,
                                        onTap: () {
                                          moveToCart(products[index]["_id"]
                                              .toString());
                                        },
                                      ),
                                      PopupMenuItem(
                                        child: Text("Remove from WishList"),
                                        value: 2,
                                        onTap: () {
                                          getRemoveItem(products[index]["_id"]
                                              .toString());
                                        },
                                      )
                                    ])
                          ],
                        )
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
              mainAxisExtent: 240,
            ),
          ),
        ],
      ),
    );
  }
}

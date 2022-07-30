import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/products_list_screen.dart';
import 'package:oim/screens/user/product_details_screen.dart';

class SearchDetailsScreen extends StatefulWidget {
  final String productname;
  const SearchDetailsScreen(this.productname);

  @override
  State<SearchDetailsScreen> createState() => _SearchDetailsScreenState();
}

class _SearchDetailsScreenState extends State<SearchDetailsScreen> {
  List products = [];

  void getProducts() async {
    var nencoded = Uri.parse(getproductsearch + '${widget.productname}');
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          products = mnjson["data"]["products"];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Search")),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
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

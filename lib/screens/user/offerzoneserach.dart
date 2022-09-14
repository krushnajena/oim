import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/product_details_screen.dart';

import '../seller/products_list_screen.dart';

class OfferZoneSearchScreen extends StatefulWidget {
  const OfferZoneSearchScreen({Key? key}) : super(key: key);

  @override
  State<OfferZoneSearchScreen> createState() => _OfferZoneSearchScreenState();
}

class _OfferZoneSearchScreenState extends State<OfferZoneSearchScreen> {
  TextEditingController txt_searchbar = new TextEditingController();
  bool show = false;

  List products = [];
  List searchResult = [];
  void getProducts() async {
    var nencoded = Uri.parse(get_ads);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);

        for (int i = 0; i < mnjson["data"]["result"].length; i++) {
          if (mnjson["data"]["result"][i]["productid"]["isdeleted"] == false &&
              mnjson["data"]["result"][i]["productid"]["instock"] == true) {
            setState(() {
              products.add(mnjson["data"]["result"][i]);
            });
          }
        }
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }

  void search(String serachtext) {
    for (int i = 0; i < products.length; i++) {
      if (products[i]["productid"]["productname"]
          .toString()
          .toLowerCase()
          .contains(txt_searchbar.text.toLowerCase())) {
        setState(() {
          searchResult.add(products[i]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.grey),
          backgroundColor: Colors.white,
          title: TextField(
            autofocus: true,
            controller: txt_searchbar,
            onChanged: (value) {
              if (value != "") {
                search(value);
              } else {
                setState(() {
                  searchResult.clear();
                  searchResult = [];
                });
              }
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search for Product...",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                suffixIcon: InkWell(
                  child: InkWell(
                    onTap: () {},
                    child: (Icon(
                      Icons.search,
                      color: Colors.grey,
                    )),
                  ),
                ),
                contentPadding: EdgeInsets.only(top: 15),
                fillColor: Colors.white,
                filled: true),
          )),
      body: CustomScrollView(
        slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                double disount = double.parse(
                        searchResult[index]["productid"]["mrp"].toString()) -
                    double.parse(searchResult[index]["productid"]
                            ["sellingprice"]
                        .toString());
                double discountPercentage = (disount /
                        double.parse(searchResult[index]["productid"]["mrp"]
                            .toString())) *
                    100;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                                searchResult[index]["productid"]["_id"]
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
                                        searchResult[index]["productid"]
                                            ["image"][0]["filename"],
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
                                  searchResult[index]["productid"]
                                          ["sellingprice"]
                                      .toString(),
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹" +
                                  searchResult[index]["productid"]["mrp"]
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
                        Text(searchResult[index]["productid"]["productname"])
                      ],
                    ),
                  ),
                );
              },
              childCount: searchResult.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              mainAxisExtent: 230,
            ),
          ),
        ],
      ),
    );
  }
}

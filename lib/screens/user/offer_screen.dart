import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:oim/constants/urls.dart';
import 'package:http/http.dart' as http;
import 'package:oim/screens/seller/products_list_screen.dart';
import 'package:oim/screens/user/offerzoneserach.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:oim/screens/widgets/imagesilder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({Key? key}) : super(key: key);

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  List imageSlider = [];

  bool isImageSliderLoaded = false;
  List categories = [];
  List products = [];
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

  getImageSlider() async {
    var encoded = Uri.parse(get_image_banner);
    http.get(encoded).then((value) async {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        setState(() {
          imageSlider = mjson["data"]["result"];
        });
        for (int i = 0; i < mjson["data"]["result"].length; i++) {
          setState(() {
            imageSlider[i]["image"] =
                baseUrl + mjson["data"]["result"][i]["image"];
          });
        }
        setState(() {
          isImageSliderLoaded = true;
        });
      }
    }).catchError((onError) {});
  }

  List sellers = [];
  String username = "";
  getStores() async {
    var encoded = Uri.parse(get_seller_and_products + "/d");

    http.get(encoded).then((value) async {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson["data"]["result"]);
        setState(() {
          sellers = mjson["data"]["seller"];
        });
        getCategories();
      }
    }).catchError((onError) {});
  }

  void getCategories() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var encoded = Uri.parse(get_categoris);
    http.get(encoded).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson);

        for (int i = 0; i < mjson["data"]["categories"].length; i++) {
          int s = 0;
          for (int k = 0; k < sellers.length; k++) {
            if (mjson["data"]["categories"][i]["_id"] ==
                sellers[k]["businesscatagories"]) {
              s = s + 1;
            }
          }
          if (s > 0) {
            setState(() {
              categories.add(
                {
                  'value': mjson["data"]["categories"][i]["_id"],
                  'label': mjson["data"]["categories"][i]["categoryname"],
                  'icon': mjson["data"]["categories"][i]["icon"]
                },
              );
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
    getStores();
    getImageSlider();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Offer Zone"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OfferZoneSearchScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              delegate: SliverAppBarDelegate(
            minHeight: 225,
            maxHeight: 225,
            child: Column(
              children: [
                Card(
                  // clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                      color: Colors.white,
                      child: Column(children: [
                        SizedBox(
                          height: 10,
                        ),
                        isImageSliderLoaded == true
                            ? ImagesCarousel(imageSlider)
                            : SizedBox(),
                      ])),
                ),
              ],
            ),
          )),
          SliverPersistentHeader(
              delegate: SliverAppBarDelegate(
            minHeight: 110,
            maxHeight: 110,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                height: 90,
                child: ListView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return categories[index]["value"] != "Restaurant"
                          ? Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Image.network(
                                          baseUrl + categories[index]["icon"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    categories[index]["label"],
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Image.asset(
                                          "images/restaurant.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Restaurant",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                    }),
              ),
            ),
          )),
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
                        Text(products[index]["productid"]["productname"])
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
              mainAxisExtent: 230,
            ),
          ),
        ],
      ),
    );
  }
}

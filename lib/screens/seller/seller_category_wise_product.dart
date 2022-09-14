import 'dart:convert';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oim/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/add_new_product_screen.dart';
import 'package:oim/screens/seller/product_edit_screen.dart';
import 'package:oim/screens/seller/promote_your_business_screen.dart';
import 'package:oim/screens/seller/seller_bottom_appbar.dart';
import 'package:oim/screens/seller/seller_product_search_screen.dart';
import 'package:oim/screens/seller/seller_subcategory_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class SellerCategoryWiseProduct extends StatefulWidget {
  final String categoryid;
  const SellerCategoryWiseProduct(this.categoryid);

  @override
  State<SellerCategoryWiseProduct> createState() =>
      _SellerCategoryWiseProductState();
}

class _SellerCategoryWiseProductState extends State<SellerCategoryWiseProduct> {
  bool isSwitched = false;
  double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2;
  int _crossAxisCount = 2;
  List catelouges = [];
  List products = [];

  void getCatelouges() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? categoryId = preferences.getString("businesscategory");
    var nencoded = Uri.parse(get_catelogues + categoryId!);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mjson;
        mjson = json.decode(resp.body);
        for (int i = 0; i < mjson["data"]["catlog"].length; i++) {
          bool isExists = false;
          var coded = Uri.parse(getSubcategoriesByCatelogid +
              mjson["data"]["catlog"][i]["_id"].toString());
          print(getSubcategoriesByCatelogid +
              mjson["data"]["catlog"][i]["_id"].toString());
          http.get(coded).then((value) {
            if (value.statusCode == 200) {
              Map mnjson;
              mnjson = json.decode(value.body);
              for (int k = 0; k < mnjson["data"]["catlog"].length; k++) {
                for (int l = 0; l < products.length; l++) {
                  print("dfghjikoplxfcgvhbjnkml,;.");
                  print("Category Id :- " +
                      mnjson["data"]["catlog"][k]["_id"].toString());

                  print("Product Id :- " +
                      products[l]["productcategoryid"].toString());
                  print("888888**************");
                  if (mnjson["data"]["catlog"][k]["_id"].toString() ==
                          products[l]["catalogueid"].toString() &&
                      isExists == false) {
                    isExists = true;
                    print("dfghjikoplxfcgvhbjnkml,;.");
                    setState(() {
                      catelouges.add(mjson["data"]["catlog"][i]);
                    });
                  }
                }
              }
            }
          });
        }
      }
    });
  }

  void updateStock(String productid, bool stockvalue, int index) {
    var nencoded = Uri.parse(post_stock_update);
    if (stockvalue == true) {
      http.post(nencoded, body: {"_id": productid, "instock": "1"}).then(
          (value) {
        if (value.statusCode == 200) {
          setState(() {
            products[index]["instock"] = stockvalue;
          });
        }
      });
    } else {
      http.post(nencoded, body: {"_id": productid, "instock": "0R"}).then(
          (value) {
        if (value.statusCode == 200) {
          setState(() {
            products[index]["instock"] = stockvalue;
          });
        }
      });
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void deleteProduct(String id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Wrap(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SpinKitRing(
                      color: primaryColor,
                      size: 40.0,
                      lineWidth: 1.2,
                    ),
                    SizedBox(height: 25.0),
                    Text(
                      'Please Wait..',
                      style: grey14MediumTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    var nencoded = Uri.parse(get_deleteproduct + id);

    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Navigator.of(context).pop();

        Navigator.of(context).pop();
        Map mnjson;
        mnjson = json.decode(resp.body);
        print(mnjson);
        getProducts();
        showInSnackBar("Product Deleted Successfully ");
      }
    });
  }

  void getProducts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString("userid");
    var nencoded = Uri.parse(get_products_byuserid + userId!);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);

        for (int i = 0; i < mnjson["data"]["product"].length; i++) {
          if (mnjson["data"]["product"][i]["isdeleted"] == false &&
              mnjson["data"]["product"][i]["catalogueid"] ==
                  widget.categoryid) {
            setState(() {
              products.add(mnjson["data"]["product"][i]);
            });
          }
        }

        getCatelouges();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCatelouges();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: scaffoldBgColor,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => SellerBottomAppBar()),
                  (Route<dynamic> route) => false),
            ),
            centerTitle: true,
            title: Text('Catalogue'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(.0),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SellerProductSearchScreen()));
                    },
                    child: Icon(Icons.search)),
              )
            ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            var a = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNewProductScreen()));
            getProducts();
          },
          isExtended: true,
          backgroundColor: Colors.orange[800],
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: Text(
            "Add new product",
            style: TextStyle(fontSize: 19, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      minHeight: 100.0,
                      maxHeight: 100.0,
                      child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: catelouges.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 30),
                                  child: InkWell(
                                    onTap: () async {
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SellerSubCategoryScreen(
                                                      catelouges[index]["_id"],
                                                      "categoryId",
                                                      catelouges,
                                                      preferences
                                                          .getString("userid")
                                                          .toString())));
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                SharedPreferences preferences =
                                                    await SharedPreferences
                                                        .getInstance();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SellerSubCategoryScreen(
                                                                catelouges[
                                                                        index]
                                                                    ["_id"],
                                                                "categoryId",
                                                                catelouges,
                                                                preferences
                                                                    .getString(
                                                                        "userid")
                                                                    .toString())));
                                              },
                                              child: Image.network(
                                                baseUrl +
                                                    catelouges[index]["image"],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          catelouges[index]["cataloguename"],
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      minHeight: 8.0,
                      maxHeight: 8.0,
                      child: Container(),
                    ),
                  ),
                  products.length > 0
                      ? SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              double disount = double.parse(
                                      products[index]["mrp"].toString()) -
                                  double.parse(products[index]["sellingprice"]
                                      .toString()
                                      .toString());
                              double discountPercentage = (disount /
                                      double.parse(
                                          products[index]["mrp"].toString())) *
                                  100;
                              return Container(
                                height: 300,
                                child: Card(
                                  child: Container(
                                    height: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(children: [
                                          Container(
                                              margin: EdgeInsets.all(3),
                                              height: 100,
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      16) /
                                                  2,
                                              child: products[index]["image"]
                                                          .length >
                                                      0
                                                  ? Image.network(
                                                      baseUrl +
                                                          products[index]
                                                                  ["image"][0]
                                                              ["filename"],
                                                      fit: BoxFit.fill,
                                                    )
                                                  : SizedBox()),
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
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  products[index]
                                                      ["productname"],
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              PopupMenuButton(
                                                  onSelected: (newValue) {
                                                    if (newValue == 1) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProductEditScreen(
                                                                      products[
                                                                              index]
                                                                          [
                                                                          "_id"])));
                                                    }
                                                  },
                                                  itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                          child: Text(
                                                              "Edit Product"),
                                                          value: 1,
                                                        ),
                                                        PopupMenuItem(
                                                          child: Text(
                                                              "Remove Product"),
                                                          value: 2,
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    CupertinoAlertDialog(
                                                                      title: new Text(
                                                                          "Confirmation"),
                                                                      content: new Text("Do you want to delete '" +
                                                                          products[index]
                                                                              [
                                                                              "productname"] +
                                                                          "' "),
                                                                      actions: <
                                                                          Widget>[
                                                                        CupertinoDialogAction(
                                                                          isDefaultAction:
                                                                              true,
                                                                          child:
                                                                              Text("Delete Product"),
                                                                          onPressed:
                                                                              () async {
                                                                            deleteProduct(products[index]["_id"]);
                                                                          },
                                                                        ),
                                                                        CupertinoDialogAction(
                                                                          child:
                                                                              Text("Exit"),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                        )
                                                                      ],
                                                                    ));

                                                            //getRemoveItem(products[index]["_id"]
                                                            //    .toString());
                                                          },
                                                        )
                                                      ]),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                  "₹" +
                                                      products[index]["mrp"]
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough)),
                                              SizedBox(width: 5),
                                              Text(
                                                  "₹" +
                                                      products[index]
                                                              ["sellingprice"]
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              SizedBox(width: 5),
                                              Text(
                                                discountPercentage
                                                        .toStringAsFixed(2) +
                                                    "%",
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
                                                products[index]["instock"]
                                                    ? "In Stock"
                                                    : "Stock Out",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: products[index]
                                                            ["instock"]
                                                        ? Colors.green
                                                        : Colors.red),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 28,
                                              child: Switch(
                                                value: products[index]
                                                    ["instock"],
                                                onChanged: (value) {
                                                  updateStock(
                                                      products[index]["_id"],
                                                      value,
                                                      index);
                                                },
                                                activeTrackColor:
                                                    Colors.lightGreenAccent,
                                                activeColor: Colors.green,
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
                                                    Icons
                                                        .remove_red_eye_outlined,
                                                    size: 10,
                                                  ),
                                                  Text(
                                                      "  Views : " +
                                                          products[index]
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
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PromoteYourBusinessScreen()));
                                                    },
                                                    child: const Text(
                                                        "Sell Faster Now",
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
                              );
                            },
                            childCount: products.length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            mainAxisExtent: 303,
                          ),
                        )
                      : SliverPersistentHeader(
                          pinned: true,
                          delegate: SliverAppBarDelegate(
                            minHeight: 100.0,
                            maxHeight: 300.0,
                            child: Column(
                              children: [
                                Container(
                                    height: 250,
                                    color: Colors.white,
                                    child: Center(
                                      child: Image.asset(
                                          "images/productlist.jpeg"),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "There is no product to show",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                  SliverGrid.extent(
                    maxCrossAxisExtent: 250,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 2.5,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

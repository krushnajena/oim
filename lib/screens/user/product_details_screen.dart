import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/models/chat_model.dart';
import 'package:oim/models/specificatiomodel.dart';
import 'package:oim/resources/firebase_repository.dart';
import 'package:oim/screens/user/cart_screen.dart';
import 'package:oim/screens/user/chat_message_screen.dart';
import 'package:oim/screens/user/storerattingscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productid;
  ProductDetailsScreen(this.productid);
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String productName = "";
  List image = [];
  String productdetails = "";
  double mrp = 0;
  double sellingprice = 0;
  String sellerid = "";
  List<Widget> images = [];

  String storename = "";
  String imageUrl = "";
  String address = "";
  double lat = 0;
  double lang = 0;
  String mobileNo = "";
  String categoryId = "";
  bool? follewed;
  double discountPercentage = 0;
  bool isLoaded = false;
  List<SpecificationModel> spesifications = [];
  List spesifica = [];

  double ratting = 0;
  int noofrattings = 0;
  double appliedRatting = 0;
  double oneStar = 0;
  double twoStar = 0;
  double threeStar = 0;
  double fourStar = 0;
  double fiveStar = 0;
  void getRattings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var encoded = Uri.parse(get_rattings + sellerid);
    print("##########################zeeeeeerrr7777777777777777777777");

    print(get_rattings + sellerid);
    print("##########################zeeeeeerrr7777777777777777777777");
    http.get(encoded).then((value) {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        double total = 0;
        for (int i = 0; i < mjson["data"]["storeratting"].length; i++) {
          total = total +
              double.parse(mjson["data"]["storeratting"][i]["applied_ratting"]
                  .toString());
          if (double.parse(mjson["data"]["storeratting"][i]["applied_ratting"]
                  .toString()) >
              4) {
            setState(() {
              fiveStar = fiveStar + 1;
            });
          } else if (double.parse(mjson["data"]["storeratting"][i]
                      ["applied_ratting"]
                  .toString()) >
              3) {
            setState(() {
              fourStar = fourStar + 1;
            });
          } else if (double.parse(mjson["data"]["storeratting"][i]
                      ["applied_ratting"]
                  .toString()) >
              2) {
            setState(() {
              threeStar = threeStar + 1;
            });
          } else if (double.parse(mjson["data"]["storeratting"][i]
                      ["applied_ratting"]
                  .toString()) >
              1) {
            setState(() {
              twoStar = twoStar + 1;
            });
          } else if (double.parse(mjson["data"]["storeratting"][i]
                      ["applied_ratting"]
                  .toString()) >
              0) {
            setState(() {
              oneStar = oneStar + 1;
            });
          }
        }

        if (total > 0) {
          setState(() {
            noofrattings = mjson["data"]["storeratting"].length;
            ratting = total / mjson["data"]["storeratting"].length;
          });
          if (ratting < 1) {
            setState(() {
              ratting = 0.5;
            });
          } else if (ratting < 1.5) {
            setState(() {
              ratting = 1;
            });
          } else if (ratting < 2) {
            setState(() {
              ratting = 1.5;
            });
          } else if (ratting < 2.5) {
            setState(() {
              ratting = 2;
            });
          } else if (ratting < 3) {
            setState(() {
              ratting = 2.5;
            });
          } else if (ratting < 3.5) {
            setState(() {
              ratting = 3;
            });
          } else if (ratting < 4) {
            setState(() {
              ratting = 3.5;
            });
          } else if (ratting < 4.5) {
            setState(() {
              ratting = 4;
            });
          } else if (ratting < 5) {
            setState(() {
              ratting = 4.5;
            });
          } else {
            setState(() {
              ratting = 5;
            });
          }
        }
      }
    });
  }

  void getSellerDetails() async {
    var nencoded = Uri.parse(get_sellerdetalsbyuserid + sellerid);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        if (mnjson["Data"]["Seller"].length > 0) {
          setState(() {
            storename = mnjson["Data"]["Seller"][0]["businessname"];
            imageUrl = mnjson["Data"]["Seller"][0]["photo"];
            address = mnjson["Data"]["Seller"][0]["streetaddress"];
            lat = mnjson["Data"]["Seller"][0]["latitude"];
            lang = mnjson["Data"]["Seller"][0]["longitude"];
            mobileNo = mnjson["Data"]["Seller"][0]["businesscontactinfo"];
            categoryId = mnjson["Data"]["Seller"][0]["businesscatagories"];
            isLoaded = true;
          });
          getRattings();
          addView();
        }
      }
    });
  }

  Future<String> validate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> result = await firestore
        .collection("players")
        .where("productid", isEqualTo: widget.productid)
        .where("sellerid", isEqualTo: sellerid)
        .where("userid", isEqualTo: preferences.getString("userid"))
        .get();

    if (result.docs.length == 0) {
      return "not available";
    } else {
      return result.docs[0].id;
    }
  }

  void sendMessage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    FirebaseRepository _repository = FirebaseRepository();
    var a = await validate();
    if (a == "not available") {
      ChatModel _players = ChatModel(
        sellerid: sellerid,
        sellername: storename,
        sellerlogo: imageUrl,
        userid: preferences.getString("userid"),
        username: preferences.getString("name"),
        productid: widget.productid,
        productname: productName,
        productlogo: image[0]["filename"],
        isDeletdByByer: "0",
        isDeletdBySeller: "0",
        productprice: sellingprice.toString(),
        isBlockedByByer: "0",
        isBlockedBySeller: "0",
      );

      var b = await _repository.addPlayerToMatchDb(_players);
      var c = await validate();
      if (c != "not available") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contex) => ChatMessage_Screen(
                    c,
                    preferences.getString("userid").toString(),
                    sellerid,
                    widget.productid,
                    "0",
                    "0")));
      } else {
        showInSnackBar("Chat Service UnAvailable! Please Try Again");
      }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (contex) => ChatMessage_Screen(
                  a,
                  preferences.getString("userid").toString(),
                  sellerid,
                  widget.productid,
                  "0",
                  "0")));
    }
  }

  void addView() {
    var nencoded = Uri.parse(postview);
    print("sssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
    http.post(nencoded, body: {
      "cid": widget.productid,
      "userid": sellerid,
      "type": "product"
    }).then((value) {
      print("-----------------------------");
      print(value.statusCode);
      if (value.statusCode == 200) {}
    });
  }

  bool itemAddedToCart = false;
  bool itemAddedToWishList = false;
  void getItemAddedToCartOrNot() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(get_item_added_or_not +
        preferences.getString("userid").toString() +
        "/cart/" +
        widget.productid);
    print(get_item_added_or_not +
        preferences.getString("userid").toString() +
        "/cart/" +
        widget.productid);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        if (mnjson["data"]["result"].length > 0) {
          setState(() {
            itemAddedToCart = true;
          });
        }
      }
    });
  }

  void getItemAddedToWishListOrNot() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("777777777");
    print(widget.productid);
    print("777777777");
    var nencoded = Uri.parse(get_item_added_or_not +
        preferences.getString("userid").toString() +
        "/wishlist/" +
        widget.productid);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        if (mnjson["data"]["result"].length > 0) {
          setState(() {
            itemAddedToWishList = true;
          });
        }
      }
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void addToCartOrWishList(String type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String userid = preferences.getString("userid").toString();
    var nencoded = Uri.parse(postAddToCart);
    print("sssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
    http.post(nencoded, body: {
      "productid": widget.productid,
      "userid": userid,
      "type": type,
      "sellerid": sellerid,
      "sellerlocation": address,
      "sellername": storename,
      "sellerlat": lat.toString(),
      "sellerlang": lang.toString()
    }).then((value) {
      print("-----------------------------");
      print(value.statusCode);
      if (value.statusCode == 200) {
        if (type == "cart") {
          setState(() {
            itemAddedToCart = true;
          });
        } else {
          setState(() {
            itemAddedToWishList = true;
          });
        }
        showInSnackBar(
            "Product Added To Your " + type.toUpperCase() + " Successfully");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductDetails();
    getItemAddedToCartOrNot();
    getItemAddedToWishListOrNot();
  }

  void getProductDetails() async {
    var nencoded = Uri.parse(get_Product_Details + widget.productid);
    print(get_Product_Details + widget.productid);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);

        setState(() {
          productName = mnjson["data"]["product"]["productname"];
          image = mnjson["data"]["product"]["image"];
          productdetails = mnjson["data"]["product"]["productdetails"];
          mrp = double.parse(mnjson["data"]["product"]["mrp"].toString());
          sellingprice = double.parse(
              mnjson["data"]["product"]["sellingprice"].toString());
          sellerid = mnjson["data"]["product"]["sellerid"];
          spesifica = mnjson["data"]["product"]["sepecification"];
          double disount = mrp - sellingprice;
          discountPercentage = (disount / mrp) * 100;
        });
        if (spesifica.length > 0) {
          print("--------------444444444");
          var asd = json.decode(spesifica[0].trim());

          setState(() {
            spesifications = List<SpecificationModel>.from(
                asd.map((x) => SpecificationModel.fromJson(x)));
          });
          print(spesifications);
        }
        print(image[0]);
        for (int i = 0; i < image.length; i++) {
          setState(() {
            images.add(Image.network(baseUrl + image[i]["filename"],
                fit: BoxFit.fill));
          });
        }
        getSellerDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 40,
                    width: 170,
                    child: RaisedButton(
                      onPressed: () {
                        print("aaaa");
                        sendMessage();
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_outlined, color: Colors.white),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Chat',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 40,
                      width: 170,
                      child: itemAddedToCart == false
                          ? RaisedButton(
                              onPressed: () {
                                addToCartOrWishList("cart");
                              },
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.shopping_bag_outlined,
                                      color: Colors.white),
                                  Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CartScreen()),
                                );
                              },
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.shopping_bag_outlined,
                                      color: Colors.white),
                                  Text(
                                    'Go to Cart',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      body: isLoaded == true
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Stack(children: [
                        ImageSlideshow(
                          width: double.infinity,
                          height: 400,
                          initialPage: 0,
                          indicatorColor: Colors.blue,
                          indicatorBackgroundColor: Colors.grey,
                          children: images,
                          isLoop: false,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 290),
                          child: Column(
                            children: [
                              Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(150),
                                  ),
                                  child: itemAddedToWishList == false
                                      ? InkWell(
                                          onTap: () {
                                            addToCartOrWishList("wishlist");
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.favorite_outlined,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {},
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.favorite_outlined,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(150),
                                  ),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.grey[400],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 15),
                    child: Text(
                      productName,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, top: 1, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          productdetails,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 15),
                    child: Text(
                      "Product Id:- " + widget.productid,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "₹ " + mrp.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "₹ " + sellingprice.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${discountPercentage.toStringAsPrecision(2)}% Off",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "Specification",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: spesifications.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(spesifications[index].key.toString()),
                                Text(spesifications[index].value.toString())
                              ],
                            );
                          })),
                  Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$storename",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 60,
                            width: 50,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Status()));
                                },
                                child: Image.network(
                                  baseUrl + imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      children: [
                        Text(ratting.toStringAsFixed(2)),
                        RatingBar(
                          ignoreGestures: true,
                          itemSize: 20,
                          allowHalfRating: true,
                          initialRating: ratting,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          ratingWidget: RatingWidget(
                            empty: Icon(Icons.star_border,
                                color: primaryColor, size: 20),
                            full: Icon(
                              Icons.star,
                              color: primaryColor,
                              size: 20,
                            ),
                            half: Icon(Icons.star_border,
                                color: primaryColor, size: 20),
                          ),
                          onRatingUpdate: (value) {
                            print(value);
                          },
                        ),
                        Text(
                          "(" + noofrattings.toString() + ")",
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StoreRattingScreen(
                                        sellerid,
                                        storename,
                                        address,
                                        imageUrl)));
                          },
                          child: Image.asset(
                            "images/star.png",
                            height: 22,
                            width: 22,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, top: 10),
                    child: Row(
                      children: [
                        Text(address),
                        Text(
                          "Open",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey[350]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          final Uri launchUri = Uri(
                            scheme: 'tel',
                            path: mobileNo,
                          );
                          await launchUrl(launchUri);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                              child: Icon(
                                Icons.call,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              "CALL",
                              style: TextStyle(color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          String name = Uri.encodeComponent(storename);
                          name = name.replaceAll('%20', '+');

                          String googleUrl =
                              'https://www.google.com/maps/search/?api=1&query=$lat,$lang';

                          print(googleUrl);

                          await launch(googleUrl);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                              child: Icon(
                                Icons.directions,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              "DIRECTION",
                              style: TextStyle(color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 10),
                    child: Text(
                      "Similar Products",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

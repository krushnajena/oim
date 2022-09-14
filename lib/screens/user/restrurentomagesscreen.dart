import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/products_list_screen.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:oim/screens/user/storerattingscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ResturentImagesScreen extends StatefulWidget {
  //const ResturentImagesScreen({Key? key}) : super(key: key);
  final String userid;
  ResturentImagesScreen(this.userid);
  @override
  State<ResturentImagesScreen> createState() => _ResturentImagesScreenState();
}

class _ResturentImagesScreenState extends State<ResturentImagesScreen> {
  String storename = "";
  String imageUrl = "";
  String address = "";
  double lat = 0;
  double lang = 0;
  String mobileNo = "";
  String categoryId = "";
  int nooffollwers = 0;
  List products = [];
  List catelouges = [];
  bool? follewed;
  double ratting = 0;
  int noofrattings = 0;
  double appliedRatting = 0;
  double oneStar = 0;
  double twoStar = 0;
  double threeStar = 0;
  double fourStar = 0;
  double fiveStar = 0;

  List<Widget> images = [];
  List food = [];
  List amb = [];
  List img = [];
  bool isImageSliderLoaded = false;
  String selectedItem = "food";

  getImageSlider() async {
    setState(() {
      images = [];
      food = [];
      amb = [];
      img = [];
    });

    var encoded = Uri.parse(getRestaurentImageBySellerId + widget.userid);
    print(get_image_banner);
    http.get(encoded).then((value) async {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson);

        for (int i = 0; i < mjson["data"]["sellerimages"].length; i++) {
          if (mjson["data"]["sellerimages"][i]["type"] == "banner") {
            setState(() {
              images.add(Image.network(
                  baseUrl + mjson["data"]["sellerimages"][i]["image"],
                  fit: BoxFit.fill));
            });
          }

          if (mjson["data"]["sellerimages"][i]["type"] == "food") {
            setState(() {
              food.add(
                mjson["data"]["sellerimages"][i]["image"],
              );
            });
          }
          if (mjson["data"]["sellerimages"][i]["type"] == "ambience") {
            setState(() {
              amb.add(
                mjson["data"]["sellerimages"][i]["image"],
              );
            });
          }
          if (mjson["data"]["sellerimages"][i]["type"] == "menu") {
            setState(() {
              img.add(
                mjson["data"]["sellerimages"][i]["image"],
              );
            });
          }
        }
        setState(() {
          isImageSliderLoaded = true;
        });
      }
    }).catchError((onError) {});
  }

  void getRattings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var encoded = Uri.parse(get_rattings + widget.userid);
    print("##########################zeeeeeerrr7777777777777777777777");

    print(get_rattings + widget.userid);
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
    var nencoded = Uri.parse(get_sellerdetalsbyuserid + widget.userid);
    print("seller id " + widget.userid);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        if (mnjson["Data"]["Seller"].length > 0) {
          setState(() {
            storename = mnjson["Data"]["Seller"][0]["businessname"];
            imageUrl = baseUrl + mnjson["Data"]["Seller"][0]["photo"];
            address = mnjson["Data"]["Seller"][0]["streetaddress"] +
                ", " +
                mnjson["Data"]["Seller"][0]["landmark"];
            lat = mnjson["Data"]["Seller"][0]["latitude"];
            lang = mnjson["Data"]["Seller"][0]["longitude"];
            mobileNo = mnjson["Data"]["Seller"][0]["businesscontactinfo"];
            categoryId = mnjson["Data"]["Seller"][0]["businesscatagories"];
          });
          getCatelouges();
        }
      }
    });
  }

  void applyRatting() async {}
  void getCatelouges() async {
    var nencoded = Uri.parse(get_catelogues + categoryId);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          catelouges = mnjson["data"]["catlog"];
        });
      }
    });
  }

  void getProducts() async {
    var nencoded = Uri.parse(get_products_byuserid + widget.userid);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);

        for (int i = 0; i < mnjson["data"]["product"].length; i++) {
          if (mnjson["data"]["product"][i]["isdeleted"] == false &&
              mnjson["data"]["product"][i]["instock"] == true) {
            setState(() {
              products.add(mnjson["data"]["product"][i]);
            });
          }
        }
        setState(() {});
        print("*****************************************");
        print(products.length);
        print("*****************************************");
      }
    });
  }

  void getNoOfFollers() async {
    var nencoded = Uri.parse(get_follwers_by_sellerid + widget.userid);
    print("%%%%%%%%%%%%%%%%%%%%%%%%%");
    print(get_follwers_by_sellerid + widget.userid);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          nooffollwers = mnjson["data"]["followers"].length;
        });
      }
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSellerDetails();
    getProducts();
    getNoOfFollers();

    getRattings();
    getImageSlider();
  }

  late TabController _controller;
  @override
  Widget build(BuildContext context) {
//    tabController = TabController(vsync: this, length: 15);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text("Photos"),
            centerTitle: true,
            bottom: new TabBar(
              tabs: [
                Text("Food (" + food.length.toString() + ")"),
                Text("Ambience (" + amb.length.toString() + ")"),
                Text("Menu (" + img.length.toString() + ")"),
              ],
            )),
        body: TabBarView(
          children: [
            CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 150,
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
                                          baseUrl + food[index],
                                        )),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: food.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 3,
                    mainAxisExtent: 170,
                  ),
                ),
              ],
            ),
            CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 150,
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
                                          baseUrl + amb[index],
                                        )),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: amb.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 3,
                    mainAxisExtent: 170,
                  ),
                )
              ],
            ),
            CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 150,
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
                                          baseUrl + img[index],
                                        )),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: img.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 3,
                    mainAxisExtent: 170,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

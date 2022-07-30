import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/provider/location_provider.dart';
import 'package:oim/screens/seller/seller_privacy_policy.dart';
import 'package:oim/screens/user/all_categories_screen.dart';
import 'package:oim/screens/user/all_category_by_select_screen.dart';
import 'package:oim/screens/user/cart_screen.dart';
import 'package:oim/screens/user/chat_screen.dart';
import 'package:oim/screens/user/location_search_screen.dart';
import 'package:oim/screens/user/mystore_screen.dart';
import 'package:oim/screens/user/offer_screen.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:oim/screens/user/resturent_details_screen.dart';
import 'package:oim/screens/user/scan_qr_code_screen.dart';
import 'package:oim/screens/user/search_screen.dart';
import 'package:oim/screens/user/seller_list_by_categoryid_screen.dart';
import 'package:oim/screens/user/store_details_screen.dart';
import 'package:oim/screens/user/user_account_screen.dart';
import 'package:oim/screens/user/user_hep_center_screen.dart';
import 'package:oim/screens/user/user_set_location_screen.dart';
import 'package:oim/screens/user/wishlish_screen.dart';
import 'package:oim/screens/widgets/imagesilder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List categories = [];

  List imageSlider = [];
  List popularStores = [];
  bool isImageSliderLoaded = false;
  List sellers = [];
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

  getImageSlider() async {
    var encoded = Uri.parse(get_image_banner);
    print(get_image_banner);
    http.get(encoded).then((value) async {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson);
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

  bool showhide = false;

  List notifications = [];
  void getNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(get_notifications);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          notifications = mnjson["data"]["notifications"];
        });
        preferences.setInt("noofnotifications", notifications.length);
      }
    });
  }

  getPopularStores() async {
    var encoded = Uri.parse(get_popular_stores);
    http.get(encoded).then((value) async {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson["data"]["result"]);
        setState(() {
          popularStores = mjson["data"]["result"];
        });
        setState(() {
          isloaded = true;
        });
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
        setState(() {
          categories.add(
            {'value': 'Restaurant', 'label': 'Restaurant', 'icon': ""},
          );
        });
      }
    });
  }

  String address = "";
  void getAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if ((preferences.getString("address") ?? "") == "") {
    } else {
      setState(() {
        address = preferences.getString("address")!;
      });
    }
  }

  bool isloaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStores();

    getImageSlider();
    getPopularStores();
    getAddress();
    getNotification();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    // final locationData = Provider.of<LocationProvider>(context, listen: false);
    return isloaded == true
        ? Scaffold(
            backgroundColor: scaffoldBgColor,
            key: _scaffoldKey,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0.1,
              backgroundColor: Colors.white,
              actions: <Widget>[
                SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      var a = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchLocation()));

                      //locationData.getCurrentPosition().then((value) async {
                    },
                    child: Center(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.location_on_outlined,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              address,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_sharp),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QrCodeScannerScreen()));
                  },
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen()));
                    },
                  ),
                ),
              ],
            ),
            drawer: Drawer(
              elevation: 10.0,
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage("images/p1.jpg"),
                          radius: 40.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Hello Oim',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25.0),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  //Here you place your menu items
                  ListTile(
                    leading: Icon(Icons.category),
                    title:
                        Text('All Categories', style: TextStyle(fontSize: 15)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllCategoryScreen()));
                      // Here you can give your route to navigate
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>CatgoryPage()));
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.store),
                    title: Text('My Stores', style: TextStyle(fontSize: 15)),
                    onTap: () {
                      // to close drawer programatically..
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyStoreScreen()));
                    },
                  ),
                  Divider(height: 3.0),
                  ListTile(
                    leading: Icon(Icons.local_offer_rounded),
                    title: Text('Offer Zone', style: TextStyle(fontSize: 15)),
                    onTap: () {
                      // Here you can give your route to navigate
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OfferScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite_outlined),
                    title: Text('My Wishlist', style: TextStyle(fontSize: 15)),
                    onTap: () {
                      // to close drawer programatically..
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WishListScreen()));
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('My Account', style: TextStyle(fontSize: 15)),
                    onTap: () {
                      // to close drawer programatically..
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserAccountScreen()));
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.chat),
                    title: Text('My Chats', style: TextStyle(fontSize: 15)),
                    onTap: () {
                      // to close drawer programatically..
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.headset_mic_outlined),
                    title: Text('Help Centre', style: TextStyle(fontSize: 15)),
                    onTap: () {
                      // to close drawer programatically..
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserHelpCenterScreen()));
                    },
                  ),
                  ListTile(
                    leading: (Icon(Icons.policy)),
                    title:
                        Text('Privacy Policy', style: TextStyle(fontSize: 15)),
                    onTap: () {
                      // to close drawer programatically..
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerPrivacyPolic()));
                    },
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 90,
                    child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return categories[index]["label"] != "Restaurant"
                              ? Container(
                                  margin: EdgeInsets.only(right: 10),
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
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AllCategofyBySelectScreen(
                                                              categories[index]
                                                                  ["value"],
                                                              categories[index]
                                                                  ["label"])));
                                            },
                                            child: Image.network(
                                              baseUrl +
                                                  categories[index]["icon"],
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
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SellerListByCategoryIdScreen(
                                                              categories[index]
                                                                  ["value"],
                                                              categories[index]
                                                                  ["label"])));
                                            },
                                            child: Image.asset(
                                              "images/restaurant.png",
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
                                );
                        }),
                  ),
                ),
                Container(
                    color: Colors.white,
                    child: Column(children: [
                      SizedBox(
                        height: 10,
                      ),
                      isImageSliderLoaded == true
                          ? ImagesCarousel(imageSlider)
                          : SizedBox(),
                    ])),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Top Brands For You",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    mainAxisExtent: 90,
                  ),
                  itemCount: popularStores.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        print(popularStores[index]["storeid"]
                            ["businesscatagories"]);
                        popularStores[index]["storeid"]["businesscatagories"] ==
                                "Restaurant"
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResturentDetailsScreen(
                                            popularStores[index]["storeid"]
                                                ["userid"])))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StoreDetailsScreen(
                                        popularStores[index]["storeid"]
                                            ["userid"])));
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 90,
                        child: InkWell(
                          onTap: () {
                            print("555555555555555333333456688766776767676");
                            print(popularStores[index]["storeid"]
                                ["businesscatagories"]);
                            popularStores[index]["storeid"]
                                        ["businesscatagories"] ==
                                    "Restaurant"
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResturentDetailsScreen(
                                                popularStores[index]["storeid"]
                                                    ["userid"])))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StoreDetailsScreen(
                                                popularStores[index]["storeid"]
                                                    ["userid"])));
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      popularStores[index]["storeid"]
                                                  ["businesscatagories"] ==
                                              "Restaurant"
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResturentDetailsScreen(
                                                          popularStores[index]
                                                                  ["storeid"]
                                                              ["userid"])))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoreDetailsScreen(
                                                          popularStores[index]["storeid"]["userid"])));
                                    },
                                    child: Image.network(
                                      baseUrl +
                                          popularStores[index]["storeid"]
                                              ["photo"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                popularStores[index]["storeid"]["businessname"],
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (context, i) {
                      int count = 0;
                      int s = 0;
                      for (int k = 0; k < sellers.length; k++) {
                        if (categories[i]["value"] ==
                            sellers[k]["businesscatagories"]) {
                          s = s + 1;
                        }
                      }

                      return s > 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categories[i]["label"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: sellers.length,
                                    itemBuilder: (context, index) {
                                      if (categories[i]["value"] ==
                                          sellers[index]
                                              ["businesscatagories"]) {
                                        count = count + 1;
                                      }
                                      return categories[i]["value"] ==
                                                  sellers[index]
                                                      ["businesscatagories"] &&
                                              count < 3
                                          ? Column(
                                              children: [
                                                sellers[index]["products"]
                                                            .length >
                                                        0
                                                    ? Container(
                                                        height: 210,
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount: sellers[
                                                                        index]
                                                                    ["products"]
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    iindex) {
                                                              //  noofrattingsf(
                                                              // index);
                                                              double disount = double.parse(sellers[index]["products"]
                                                                              [iindex][
                                                                          "mrp"]
                                                                      .toString()) -
                                                                  double.parse(sellers[index]
                                                                              [
                                                                              "products"][iindex]
                                                                          [
                                                                          "sellingprice"]
                                                                      .toString());
                                                              double
                                                                  discountPercentage =
                                                                  (disount /
                                                                          double.parse(
                                                                              sellers[index]["products"][iindex]["mrp"].toString())) *
                                                                      100;

                                                              return sellers[index]["products"][iindex]
                                                                              [
                                                                              "instock"] ==
                                                                          true &&
                                                                      sellers[index]["products"][iindex]
                                                                              [
                                                                              "isdeleted"] ==
                                                                          false
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => ProductDetailsScreen(sellers[index]["products"][iindex]["_id"].toString())));
                                                                      },
                                                                      child:
                                                                          SizedBox(
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              210,
                                                                          width:
                                                                              160,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 2, bottom: 12),
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                  child: SizedBox(
                                                                                    height: 150,
                                                                                    width: 150,
                                                                                    child: Image.network(
                                                                                      baseUrl + sellers[index]["products"][iindex]["image"][0]["filename"],
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 2),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            sellers[index]["products"][iindex]["productname"],
                                                                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Text(
                                                                                                  '\₹${sellers[index]["products"][iindex]["mrp"]}',
                                                                                                  style: TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough),
                                                                                                ),
                                                                                                Text(
                                                                                                  '    \₹${sellers[index]["products"][iindex]["sellingprice"]}',
                                                                                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                                                                                ),
                                                                                                Text(
                                                                                                  '  ${discountPercentage.toStringAsFixed(0)}% off',
                                                                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : SizedBox();
                                                            }),
                                                      )
                                                    : SizedBox(),
                                                sellerwidget(index)
                                              ],
                                            )
                                          : SizedBox();
                                    })
                              ],
                            )
                          : SizedBox();
                    })
              ],
            )),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  String twlevehourtime(int time) {
    if (time == 13) {
      return "01";
    } else if (time == 14) {
      return "02";
    } else if (time == 15) {
      return "03";
    } else if (time == 16) {
      return "04";
    } else if (time == 17) {
      return "05";
    } else if (time == 18) {
      return "06";
    } else if (time == 19) {
      return "07";
    } else if (time == 20) {
      return "08";
    } else if (time == 21) {
      return "09";
    } else if (time == 22) {
      return "10";
    } else if (time == 23) {
      return "11";
    } else {
      return "12";
    }
  }

  Widget sellerwidget(int index) {
    double ratting = 0;
    int noofrattings = 0;
    double appliedRatting = 0;
    double oneStar = 0;
    double twoStar = 0;
    double threeStar = 0;
    double fourStar = 0;
    double fiveStar = 0;
    double total = 0;
    for (int i = 0; i < sellers[index]["rattings"].length; i++) {
      if (sellers[index]["userid"].toString() ==
          sellers[index]["rattings"][i]["storeid"].toString()) {
        noofrattings = noofrattings + 1;
        total = total +
            double.parse(
                sellers[index]["rattings"][i]["applied_ratting"].toString());
      }
    }
    if (total > 0) {
      ratting = total / noofrattings;

      if (ratting < 1) {
        ratting = 0.5;
      } else if (ratting < 1.5) {
        ratting = 1;
      } else if (ratting < 2) {
        ratting = 1.5;
      } else if (ratting < 2.5) {
        ratting = 2;
      } else if (ratting < 3) {
        ratting = 2.5;
      } else if (ratting < 3.5) {
        ratting = 3;
      } else if (ratting < 4) {
        ratting = 3.5;
      } else if (ratting < 4.5) {
        ratting = 4;
      } else if (ratting < 5) {
        ratting = 4.5;
      } else {
        ratting = 5;
      }
    }
    DateTime date = DateTime.now();

    String day = DateFormat('EEEE').format(date);
    String opeingText = "";
    bool isClosed = false;
    if (day == "Sunday") {
      if (sellers[index].containsKey("sundayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["sundayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["sundayclosingtime"].toString().split(':')[0]);
        if (openingtime <= date.hour && closingtime > date.hour) {
          opeingText = "Open . Closes " +
              twlevehourtime(closingtime) +
              ":" +
              sellers[index]["sundayclosingtime"].toString().split(':')[1];
          isClosed = false;
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              twlevehourtime(int.parse(sellers[index]["mondayopeningtime"]
                  .toString()
                  .split(':')[0])) +
              ":" +
              sellers[index]["mondayopeningtime"].toString().split(':')[1];
          " Mon";
        }
      }
    } else if (day == "Monday") {
      if (sellers[index].containsKey("mondayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["mondayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["mondayclosingtime"].toString().split(':')[0]);

        if (openingtime <= date.hour && closingtime > date.hour) {
          opeingText = "Open . Closes " +
              twlevehourtime(closingtime) +
              ":" +
              sellers[index]["mondayclosingtime"].toString().split(':')[1];
          isClosed = false;
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              twlevehourtime(int.parse(sellers[index]["tuesdayopeningtime"]
                  .toString()
                  .split(':')[0])) +
              ":" +
              sellers[index]["tuesdayopeningtime"].toString().split(':')[1];
          " Tue";
        }
      }
    } else if (day == "Tuesday") {
      if (sellers[index].containsKey("tuesdayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["tuesdayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["tuesdayclosingtime"].toString().split(':')[0]);

        if (openingtime <= date.hour && closingtime > date.hour) {
          opeingText = "Open . Closes " +
              twlevehourtime(closingtime) +
              ":" +
              sellers[index]["tuesdayclosingtime"].toString().split(':')[1];
          isClosed = false;
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              twlevehourtime(int.parse(sellers[index]["wednesdayopeningtime"]
                  .toString()
                  .split(':')[0])) +
              ":" +
              sellers[index]["wednesdayopeningtime"].toString().split(':')[1];
          " Wed";
        }
      }
    } else if (day == "Wednesday") {
      if (sellers[index].containsKey("wednesdayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["wednesdayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["wednesdayclosingtime"].toString().split(':')[0]);

        if (openingtime <= date.hour && closingtime > date.hour) {
          opeingText = "Open . Closes " +
              twlevehourtime(closingtime) +
              ":" +
              sellers[index]["wednesdayclosingtime"].toString().split(':')[1];
          isClosed = false;
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              twlevehourtime(int.parse(sellers[index]["tuesdayopeningtime"]
                  .toString()
                  .split(':')[0])) +
              ":" +
              sellers[index]["tuesdayopeningtime"].toString().split(':')[1];
          " Thu";
        }
      }
    } else if (day == "Thursday") {
      if (sellers[index].containsKey("thursdayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["thursdayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["tuesdayclosingtime"].toString().split(':')[0]);

        if (openingtime <= date.hour && closingtime > date.hour) {
          opeingText = "Open . Closes " +
              twlevehourtime(closingtime) +
              ":" +
              sellers[index]["tuesdayclosingtime"].toString().split(':')[1];
          isClosed = false;
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              twlevehourtime(int.parse(sellers[index]["fridayopeningtime"]
                  .toString()
                  .split(':')[0])) +
              ":" +
              sellers[index]["fridayopeningtime"].toString().split(':')[1];
          " Fri";
        }
      }
    } else if (day == "Friday") {
      if (sellers[index].containsKey("fridayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["fridayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["fridayclosingtime"].toString().split(':')[0]);

        if (openingtime <= date.hour && closingtime > date.hour) {
          opeingText = "Open . Closes " +
              twlevehourtime(closingtime) +
              ":" +
              sellers[index]["fridayclosingtime"].toString().split(':')[1];
          isClosed = false;
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              twlevehourtime(int.parse(sellers[index]["saturdayopeningtime"]
                  .toString()
                  .split(':')[0])) +
              ":" +
              sellers[index]["saturdayopeningtime"].toString().split(':')[1];
          " Sat";
        }
      }
    } else if (day == "Saturday") {
      if (sellers[index].containsKey("saturdayopeningtime")) {
        int openingtime = int.parse(
            sellers[index]["saturdayopeningtime"].toString().split(':')[0]);
        int closingtime = int.parse(
            sellers[index]["saturdayclosingtime"].toString().split(':')[0]);

        if (openingtime <= date.hour && closingtime > date.hour) {
          opeingText = "Open . Closes " +
              twlevehourtime(closingtime) +
              ":" +
              sellers[index]["saturdayclosingtime"].toString().split(':')[1];
          isClosed = false;
        } else if (closingtime < date.hour) {
          isClosed = true;
          opeingText = "Opens " +
              twlevehourtime(int.parse(sellers[index]["sundayopeningtime"]
                  .toString()
                  .split(':')[0])) +
              ":" +
              sellers[index]["sundayopeningtime"].toString().split(':')[1];
          " Sun";
        }
      }
    }
    return InkWell(
      onTap: () {
        sellers[index]["businesscatagories"] == "Restaurant"
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ResturentDetailsScreen(sellers[index]["userid"])))
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StoreDetailsScreen(sellers[index]["userid"])));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sellers[index]["businessname"],
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(ratting.toString()),
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
                      Text("(" + noofrattings.toString() + ")")
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                    child: Text(
                      sellers[index]["streetaddress"],
                    ),
                  ),
                  Text("In-store shopping"),
                  isClosed == true
                      ? Row(
                          children: [
                            Text(
                              "Closed",
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(opeingText)
                          ],
                        )
                      : Text(opeingText)
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                    child: SizedBox(
                      width: 60,
                      child: Row(
                        children: [
                          Icon(
                            Icons.call,
                            color: Colors.blue,
                          ),
                          Text(
                            '  Call',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    onPressed: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: sellers[index]["businesscontactinfo"],
                      );
                      await launchUrl(launchUri);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15.0),
                  child: RaisedButton(
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions,
                            color: Colors.blue,
                          ),
                          Text(
                            '  Directions',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    onPressed: () async {
                      String googleUrl =
                          'https://www.google.com/maps/search/?api=1&query=${sellers[index]["latitude"]},${sellers[index]["longitude"]}';

                      print(googleUrl);

                      await launch(googleUrl);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15.0),
                  child: RaisedButton(
                    child: SizedBox(
                      width: 70,
                      child: Row(
                        children: [
                          Icon(
                            Icons.share,
                            color: Colors.blue,
                          ),
                          Text(
                            '  Share',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 20, bottom: 10),
                child: Divider(
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
  }
}

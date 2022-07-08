import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/my_qr_screen.dart';
import 'package:oim/screens/seller/promote_your_business_screen.dart';
import 'package:oim/screens/seller/seller_store_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SellerDashBoardScreen extends StatefulWidget {
  const SellerDashBoardScreen({Key? key}) : super(key: key);

  @override
  State<SellerDashBoardScreen> createState() => Seller_DashBoardScreenState();
}

class Seller_DashBoardScreenState extends State<SellerDashBoardScreen> {
  String? businessName;
  String selectedval = "Life Time";
  String photo = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoreDetails();
    getSellerDetails();
  }

  void getSellerDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(
        get_sellerdetalsbyuserid + preferences.getString("userid").toString());

    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);

        print(mnjson);
        if (mnjson["Data"]["Seller"].length > 0) {
          setState(() {
            photo = mnjson["Data"]["Seller"][0]["photo"].toString();
          });
        }
      }
    });
  }

  void getStoreDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      businessName = preferences.getString("businessname");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.blue[700],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 20),
                      child: SizedBox(
                        height: 50,
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
                              baseUrl + photo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        left: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome",
                            style:
                                TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            businessName.toString(),
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 125.0),
                  child: Center(
                    child: SizedBox(
                      height: 145,
                      width: 360,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 30, left: 15, top: 30, right: 15),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            //Store Page;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SellerStoreViewScreen()));
                                          },
                                          child: Container(
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons
                                                  .store_mall_directory_outlined,
                                              size: 35,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text("View My Store")
                                      ],
                                    ),
                                    Container(
                                        width: 1, color: Colors.grey[300]),
                                    Column(
                                      children: [
                                        Container(
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              //color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                            child:
                                                Image.asset("images/wpp.png")),
                                        SizedBox(height: 5),
                                        Text("Share Store"),
                                      ],
                                    ),
                                    Container(
                                        width: 1, color: Colors.grey[300]),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyQrScreen()));
                                          },
                                          child: Container(
                                              width: 45,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue[700],
                                              ),
                                              child: Icon(
                                                Icons.qr_code_2,
                                                size: 35,
                                                color: Colors.white,
                                              )),
                                        ),
                                        SizedBox(height: 5),
                                        Text("My Store QR")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    child: ImageSlideshow(
                      height: 150,
                      initialPage: 0,
                      indicatorColor: Colors.blue,
                      indicatorBackgroundColor: Colors.grey,
                      children: [
                        Image.asset('images/nike.png', fit: BoxFit.fill),
                        Image.asset('images/reb.png', fit: BoxFit.fill),
                        Image.asset('images/sony.png', fit: BoxFit.fill),
                      ],
                      isLoop: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        'images/img.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                    ClipRRect(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PromoteYourBusinessScreen()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 205),
                          color: Colors.blue,
                          width: double.infinity,
                          height: 40,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 217,
                      ),
                      child: Center(
                          child: Text(
                        "START ADVERTISING NOW",
                        style: TextStyle(color: Colors.white),
                      )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Overview",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          selectedval,
                          style: TextStyle(color: Colors.black),
                        ),
                        PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () {
                                setState(() {
                                  selectedval = "Today";
                                });
                              },
                              value: 1,
                              child: Text("Today"),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                setState(() {
                                  selectedval = "Yesterday";
                                });
                              },
                              value: 2,
                              child: Text("Yesterday"),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                setState(() {
                                  selectedval = "This Week";
                                });
                              },
                              value: 3,
                              child: Text("This Week"),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                setState(() {
                                  selectedval = "This Month";
                                });
                              },
                              value: 4,
                              child: Text("This Month"),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                setState(() {
                                  selectedval = "Life Time";
                                });
                              },
                              value: 5,
                              child: Text("Life Time"),
                            ),
                          ],
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          //offset: Offset(0, 80),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: Card(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 45,
                              ),
                              Text(
                                "PRODUCT VIEWS",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text("0",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: Card(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 45,
                              ),
                              Text(
                                "STORE VIEWS",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text("0",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: Card(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 45,
                              ),
                              Text(
                                "FOLLOWERS",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text("0",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: Card(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 45,
                              ),
                              Text(
                                "LISTINGS",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text("0",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: SizedBox(
                  height: 120,
                  width: MediaQuery.of(context).size.width - 16,
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45,
                        ),
                        Text(
                          "RATINGS",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text("0",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

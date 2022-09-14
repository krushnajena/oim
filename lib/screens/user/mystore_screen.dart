import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/store_details_screen.dart';
import 'package:oim/screens/user/story_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyStoreScreen extends StatefulWidget {
  const MyStoreScreen({Key? key}) : super(key: key);

  @override
  State<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {
  List stores = [];
  void getStoreDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded =
        Uri.parse(mystores + preferences.getString("userid").toString());
    print("***********************");
    print(mystores + preferences.getString("userid").toString());
    http.get(nencoded).then((resp) {
      Map mnjson;
      mnjson = json.decode(resp.body);
      print(mnjson.length);
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      setState(() {
        stores = mnjson["data"]["followers"];
      });

      print(mnjson);
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoreDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Stores"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return stores[index]["sellerdetails"].length > 0
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StoreDetailsScreen(
                                        stores[index]["sellerdetails"][0]
                                            ["userid"])));
                          },
                          child: Card(
                              elevation: 10,
                              child: Column(
                                children: [
                                  Stack(children: [
                                    SizedBox(
                                        width: double.infinity,
                                        height: 90,
                                        child: Image.network(
                                          baseUrl +
                                              stores[index]["sellerdetails"][0]
                                                  ["photo"],
                                          fit: BoxFit.cover,
                                        )),
                                    Center(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 60),
                                        width: 60.0,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff7c94b6),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              baseUrl +
                                                  stores[index]["sellerdetails"]
                                                      [0]["photo"],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Text(
                                    stores[index]["sellerdetails"][0]
                                        ["businessname"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Container(
                                    child: Card(
                                        color: Colors.blue[200],
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 1.0,
                                              bottom: 1.0),
                                          child: Text(
                                            stores[index]["sellerdetails"][0]
                                                        ["category"] !=
                                                    null
                                                ? stores[index]["sellerdetails"]
                                                        [0]["category"]
                                                    .toString()
                                                    .toUpperCase()
                                                : "Null",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      stores[index]["sellerdetails"][0]
                                              ["streetaddress"] +
                                          ", " +
                                          stores[index]["sellerdetails"][0]
                                              ["landmark"],
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      stores[index]["sellerdetails"][0]
                                                  ["nooffollowers"] !=
                                              null
                                          ? stores[index]["sellerdetails"][0]
                                              ["nooffollowers"]
                                          : "Null",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              )),
                        )
                      : SizedBox();
                },
                childCount: stores.length,
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
      ),
    );
  }
}

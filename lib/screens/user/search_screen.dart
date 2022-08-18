import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/provider/location_provider.dart';
import 'package:oim/screens/user/all_category_by_select_screen.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:oim/screens/user/search_details_screen.dart';
import 'package:oim/screens/user/seller_list_by_categoryid_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List categories = [];

  bool isloaded = false;

  List popularStores = [];
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
        setState(() {
          categories.add(
            {'value': 'Restaurant', 'label': 'Restaurant', 'icon': ""},
          );
        });
      }
    });
  }

  TextEditingController txt_searchbar = new TextEditingController();
  bool show = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getStores();
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

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
              if (value == "") {
                setState(() {
                  show = false;
                });
              } else {
                setState(() {
                  show = true;
                });
              }
              locationData.searchProdcut(value);
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search for Product...",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                suffixIcon: InkWell(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SearchDetailsScreen(txt_searchbar.text)));
                    },
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
      body: locationData.psearchResults != null &&
              locationData.psearchResults!.length != 0 &&
              show == true
          ? ListView.builder(
              itemCount: locationData.psearchResults!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    locationData.psearchResults![index].productname.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchDetailsScreen(
                                locationData.psearchResults![index].productname
                                    .toString())));
                    //exit(0);
                  },
                );
              })
          : CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return categories[index]["label"] != "Restaurant"
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
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
                                            baseUrl + categories[index]["icon"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    categories[index]["label"],
                                    style: TextStyle(
                                        fontSize: 12,
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
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
                                  ),
                                  Text(
                                    categories[index]["label"],
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                    },
                    childCount: categories.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 153,
                  ),
                ),
              ],
            ),
    );
  }
}

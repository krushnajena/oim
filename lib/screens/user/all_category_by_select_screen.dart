import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/seller_list_by_categoryid_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllCategofyBySelectScreen extends StatefulWidget {
  final String categoryId, categoryName;
  const AllCategofyBySelectScreen(this.categoryId, this.categoryName);

  @override
  State<AllCategofyBySelectScreen> createState() =>
      _AllCategofyBySelectScreenState();
}

class _AllCategofyBySelectScreenState extends State<AllCategofyBySelectScreen> {
  List categories = [];
  List cateloues = [];
  String categoryId = "";
  String categoryName = "";
  int selecedIndex = 0;

  String catelogId = "";
  String catelogName = "";
  int selecedcatalogIndex = 0;

  void getCategories() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var encoded = Uri.parse(get_categoris);
    http.get(encoded).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson);
        int l = 0;
        for (int i = 0; i < mjson["data"]["categories"].length; i++) {
          int s = 0;
          for (int k = 0; k < sellers.length; k++) {
            if (mjson["data"]["categories"][i]["_id"] ==
                sellers[k]["businesscatagories"]) {
              s = s + 1;
            }
          }
          if (s > 0) {
            if (mjson["data"]["categories"][i]["categoryname"] ==
                widget.categoryName) {
              setState(() {
                categoryId = mjson["data"]["categories"][i]["_id"];
                categoryName = mjson["data"]["categories"][i]["categoryname"];
                selecedIndex = l;
              });
              getCatlouges();
            }
            // l = l+1;
            setState(() {
              categories.add(
                {
                  'value': mjson["data"]["categories"][i]["_id"],
                  'label': mjson["data"]["categories"][i]["categoryname"],
                  'icon': mjson["data"]["categories"][i]["icon"]
                },
              );
              l = l + 1;
            });
          }
        }

        setState(() {
          categories.add(
            {'value': 'Restaurant', 'label': 'Restaurant', 'icon': ""},
          );
        });

        getCatlouges();
      }
    });
  }

  List catelouges = [];
  List subcatelouges = [];

  void getsubcatgories() async {
    var nencoded = Uri.parse(getSubcategoriesByCatelogid + catelogId!);
    print(get_catelogues + categoryId);
    http.get(nencoded).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        Map mnjson;
        mnjson = json.decode(value.body);
        setState(() {
          subcatelouges = mnjson["data"]["catlog"];
        });
      }
    });
  }

  void getCatlouges() async {
    var nencoded = Uri.parse(get_catelogues + categoryId!);
    print(get_catelogues + categoryId);
    http.get(nencoded).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        Map mnjson;
        mnjson = json.decode(value.body);
        setState(() {
          catelouges = mnjson["data"]["catlog"];
        });
        if (catelouges.length > 0) {
          setState(() {
            catelogId = catelouges[0]["_id"];
            catelogName = catelouges[0]["cataloguename"];
            selecedcatalogIndex = 0;
          });
          getsubcatgories();
        }
      }
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStores();
    // getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: Text("All Categories"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 100,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[50],
              child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              categoryId = categories[index]["value"];
                              selecedIndex = index;
                              getCatlouges();
                            });
                          },
                          child: Container(
                            color: selecedIndex == index
                                ? scaffoldBgColor
                                : Colors.white,
                            height: 100,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 65,
                                  width: 65,
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          categoryId =
                                              categories[index]["value"];
                                          selecedIndex = index;
                                          getCatlouges();
                                        });
                                      },
                                      child: Image.network(
                                        baseUrl + categories[index]["icon"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(categories[index]["label"]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            categoryName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: catelouges.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        setState(() {
                                          catelogId = catelouges[index]["_id"];
                                          catelogName = catelouges[index]
                                              ["cataloguename"];
                                          selecedcatalogIndex = index;
                                        });
                                        getsubcatgories();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 65,
                                              width: 65,
                                              child: Card(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      catelogId =
                                                          catelouges[index]
                                                              ["_id"];
                                                      catelogName =
                                                          catelouges[index]
                                                              ["cataloguename"];
                                                      selecedcatalogIndex =
                                                          index;
                                                    });
                                                    getsubcatgories();
                                                  },
                                                  child: Image.network(
                                                    baseUrl +
                                                        catelouges[index]
                                                            ["image"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              catelouges[index]
                                                  ["cataloguename"],
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ));
                                }),
                          ),
                        ],
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              catelogName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          //  maxCrossAxisExtent: 120,
                                          childAspectRatio: 3 / 3,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5),
                                  itemCount: subcatelouges.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SellerListByCategoryIdScreen(
                                                          subcatelouges[index]
                                                              ["_id"],
                                                          subcatelouges[index][
                                                              "cataloguename"])));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 65,
                                                width: 65,
                                                child: Card(
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => SellerListByCategoryIdScreen(
                                                                  subcatelouges[
                                                                          index]
                                                                      ["_id"],
                                                                  subcatelouges[
                                                                          index]
                                                                      [
                                                                      "cataloguename"])));
                                                    },
                                                    child: Image.network(
                                                      baseUrl +
                                                          subcatelouges[index]
                                                              ["image"],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                subcatelouges[index]
                                                    ["cataloguename"],
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ));
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

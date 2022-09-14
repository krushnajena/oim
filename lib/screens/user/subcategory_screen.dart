import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/all_categories_screen.dart';
import 'package:oim/screens/user/seller_list_by_categoryid_screen.dart';
import 'package:oim/screens/user/storedetailswithspecifiedcategoryproducts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SubCategoryScreen extends StatefulWidget {
  final String categogryid;
  final String bcategories, userid;
  final List catagories;
  const SubCategoryScreen(
      this.categogryid, this.bcategories, this.catagories, this.userid);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
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
        for (int i = 0; i < mjson["data"]["categories"].length; i++) {
          if (widget.categogryid == mjson["data"]["categories"][i]["_id"]) {
            setState(() {
              categoryId = mjson["data"]["categories"][i]["_id"];
              categoryName = mjson["data"]["categories"][i]["categoryname"];
              selecedIndex = i;
            });
            getCatlouges();
          }
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
        setState(() {
          categories.add(
            {'value': 'Restaurant', 'label': 'Restaurant', 'icon': ""},
          );
        });
      }
    });
  }

  List catelouges = [];
  List subcatelouges = [];

  void getsubcatgories() async {
    setState(() {
      subcatelouges = [];
    });

    var nencoded = Uri.parse(getSubcategoriesByCatelogid + catelogId);
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
    /// SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(get_catelogues + widget.bcategories);
    print(get_catelogues + categoryId);
    http.get(nencoded).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        Map mnjson;
        mnjson = json.decode(value.body);
        setState(() {
          catelouges = widget.catagories;
        });
        if (catelouges.length > 0) {
          for (int i = 0; i < catelouges.length; i++) {
            if (widget.categogryid == catelouges[i]["_id"]) {
              setState(() {
                catelogId = catelouges[i]["_id"];
                catelogName = catelouges[i]["cataloguename"];
                selecedcatalogIndex = i;
              });
              getsubcatgories();
            }
          }
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCatlouges();
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
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: catelouges.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                setState(() {
                                  catelogId = catelouges[index]["_id"];
                                  catelogName =
                                      catelouges[index]["cataloguename"];
                                  selecedcatalogIndex = index;
                                });
                                getsubcatgories();
                              },
                              child: Container(
                                color: selecedIndex == index
                                    ? scaffoldBgColor
                                    : Colors.white,
                                //margin: EdgeInsets.only(right: 10),
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
                                              BorderRadius.circular(50.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              catelogId =
                                                  catelouges[index]["_id"];
                                              catelogName = catelouges[index]
                                                  ["cataloguename"];
                                              selecedcatalogIndex = index;
                                            });
                                            getsubcatgories();
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
                              ));
                        }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sub Categories",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
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
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  itemCount: subcatelouges.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoreDetailsWithSpecifiedProductCatagoryId(
                                                          widget.userid,
                                                          subcatelouges[index]
                                                              ["_id"])));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 50,
                                                width: 50,
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
                                                              builder: (context) =>
                                                                  StoreDetailsWithSpecifiedProductCatagoryId(
                                                                      widget
                                                                          .userid,
                                                                      subcatelouges[
                                                                              index]
                                                                          [
                                                                          "_id"])));
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

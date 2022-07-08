import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/all_category_by_select_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List categories = [];
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Theme(
            data: ThemeData(
              hintColor: Colors.transparent,
            ),
            child: Container(
              height: 42,
              child: TextField(
                onChanged: (value) {},
                decoration: InputDecoration(
                    hintText: "Search from Product...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    prefixIcon: (Icon(
                      Icons.search,
                      color: Colors.grey,
                    )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    fillColor: Color(0XFFEEEEEE),
                    filled: true),
              ),
            )),
      ),
      body: CustomScrollView(
        slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return categories[index]["label"] != "Restaurant"
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AllCategofyBySelectScreen(
                                          categories[index]["value"],
                                          categories[index]["label"])));
                        },
                        child: SizedBox(
                          height: 150,
                          width: 170,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          baseUrl + categories[index]["icon"],
                                        )),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                categories[index]["label"],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 150,
                          width: 170,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 130,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          "images/restaurant.png",
                                        )),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(categories[index]["label"])
                            ],
                          ),
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

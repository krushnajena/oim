import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/city_screen.dart';
import 'package:oim/screens/user/user_bottom_appbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:oim/models/location_model.dart';

import 'package:oim/provider/location_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchLocation extends StatefulWidget {
  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List<LocationModel> recentSearches = [];
  List states = [];
  bool show = false;
  @override
  void initState() {
    super.initState();
    getstates();
  }

  void getstates() {
    var nencoded = Uri.parse(get_states);

    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          states = mnjson["data"]["states"];
        });
      }
    });
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
          title: Theme(
              data: ThemeData(
                hintColor: Colors.transparent,
              ),
              child: Container(
                height: 42,
                child: TextField(
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
                    locationData.searchPlaces(value);
                  },
                  decoration: InputDecoration(
                      hintText: "Search from area, street name...",
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
        body: SafeArea(
            child: Column(children: [
          SizedBox(
            height: 10,
          ),
          locationData.searchResults != null &&
                  locationData.searchResults!.length != 0 &&
                  show == true
              ? Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                        itemCount: locationData.searchResults!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              locationData.searchResults![index].areaname
                                  .toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            onTap: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              print("--------------");
                              print(locationData.searchResults![index].areaname
                                  .toString());
                              print("--------------");

                              preferences.setString(
                                  "address",
                                  locationData.searchResults![index].areaname
                                      .toString());
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          UserBottomAppBar()),
                                  (Route<dynamic> route) => false);
                            },
                          );
                        }),
                  ),
                )
              : Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                        itemCount: states.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              states[index]["statename"].toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CityScreen(
                                          states[index]["_id"].toString(),
                                          states[index]["statename"]
                                              .toString())));
                            },
                          );
                        }),
                  ),
                ),
        ])));
  }
}

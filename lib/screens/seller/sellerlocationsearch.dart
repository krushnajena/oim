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

class SellerLocationSeacrhScreen extends StatefulWidget {
  const SellerLocationSeacrhScreen({Key? key}) : super(key: key);

  @override
  State<SellerLocationSeacrhScreen> createState() =>
      _SellerLocationSeacrhScreenState();
}

class _SellerLocationSeacrhScreenState
    extends State<SellerLocationSeacrhScreen> {
  List<LocationModel> recentSearches = [];
  List states = [];
  bool show = false;
  String statename = '';
  String stateid = '';
  String cityname = '';
  String cityid = '';
  String areaname = '';
  String areaid = '';
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

  List area = [];
  List city = [];

  void getcity() {
    var nencoded = Uri.parse(get_city + stateid);

    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          city = mnjson["data"]["city"];
        });
      }
    });
  }

  void getarea() {
    var nencoded = Uri.parse(getareabycityid + cityid);

    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          area = mnjson["data"]["area"];
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
            title: Text("Set Location")),
        body: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: statename != "" && cityname == ""
                ? InkWell(
                    onTap: () {
                      setState(() {
                        statename = "";
                      });
                    },
                    child: Icon(Icons.arrow_back),
                  )
                : cityname != ""
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            cityname = "";
                          });
                        },
                        child: Icon(Icons.arrow_back),
                      )
                    : SizedBox(),
          ),
          SizedBox(
            height: 10,
          ),
          statename == ""
              ? Expanded(
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
                              setState(() {
                                stateid = states[index]["_id"].toString();
                                statename =
                                    states[index]["statename"].toString();
                              });
                              getcity();
                            },
                          );
                        }),
                  ),
                )
              : cityname == ""
                  ? Expanded(
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                            itemCount: city.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  city[index]["cityname"].toString(),
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  setState(() {
                                    cityid = city[index]["_id"].toString();
                                    cityname =
                                        city[index]["cityname"].toString();
                                  });
                                  getarea();
                                },
                              );
                            }),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                            itemCount: area.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  area[index]["areaname"].toString(),
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () async {
                                  var adr = {
                                    "city": cityname,
                                    "cityid": cityid,
                                    "stateid": stateid,
                                    "statename": statename,
                                    "areaid": area[index]["_id"].toString(),
                                    "areaname":
                                        area[index]["areaname"].toString()
                                  };
                                  Navigator.pop(context, adr);
                                },
                              );
                            }),
                      ),
                    ),
        ])));
  }
}

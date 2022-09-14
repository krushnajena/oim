import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:http/http.dart' as http;
import 'package:oim/screens/user/user_bottom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AraaScreen extends StatefulWidget {
  final String stateid;
  final String statename;

  final String cityid;
  final String cityname;
  const AraaScreen(this.stateid, this.statename, this.cityid, this.cityname);

  @override
  State<AraaScreen> createState() => _AraaScreenState();
}

class _AraaScreenState extends State<AraaScreen> {
  List area = [];
  @override
  void initState() {
    super.initState();
    getarea();
  }

  void getarea() {
    var nencoded = Uri.parse(getareabycityid + widget.cityid);
    print(getareabycityid + widget.cityid);
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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.cityname + ", " + widget.statename),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
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
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        print("--------------");

                        print("--------------");
                        if ((preferences.getStringList("recentaddress") ??
                                "") ==
                            "") {
                          List<String> str = [];

                          str.add(area[index]["areaname"].toString() +
                              ", " +
                              widget.cityname);
                          preferences.setStringList("recentaddress", str);
                        } else {
                          List<String>? str =
                              preferences.getStringList("recentaddress");
                          str!.add(area[index]["areaname"].toString() +
                              ", " +
                              widget.cityname);
                          preferences.setStringList("recentaddress", str);
                        }

                        preferences.setString(
                            "address",
                            area[index]["areaname"].toString() +
                                ", " +
                                widget.cityname +
                                ", " +
                                widget.statename);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserBottomAppBar()),
                            (Route<dynamic> route) => false);
                      },
                    );
                  }),
            ),
          ),
        ])));
  }
}

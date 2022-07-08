import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:http/http.dart' as http;
import 'package:oim/screens/user/area_screen.dart';

class CityScreen extends StatefulWidget {
  final String stateid;
  final String statename;
  const CityScreen(this.stateid, this.statename);

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  List city = [];
  @override
  void initState() {
    super.initState();
    getcity();
  }

  void getcity() {
    var nencoded = Uri.parse(get_city + widget.stateid);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.statename),
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
                  itemCount: city.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        city[index]["cityname"].toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AraaScreen(
                                    city[index]["_id"].toString(),
                                    city[index]["cityname"].toString(),
                                    widget.stateid,
                                    widget.statename)));
                      },
                    );
                  }),
            ),
          ),
        ])));
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/provider/location_provider.dart';
import 'package:oim/screens/seller/product_edit_screen.dart';
import 'package:oim/screens/seller/seller_product_serach_details_screen.dart';
import 'package:oim/screens/user/all_category_by_select_screen.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SellerProductSearchScreen extends StatefulWidget {
  const SellerProductSearchScreen({Key? key}) : super(key: key);

  @override
  State<SellerProductSearchScreen> createState() =>
      _SellerProductSearchScreenState();
}

class _SellerProductSearchScreenState extends State<SellerProductSearchScreen> {
  bool show = false;
  TextEditingController txt_searchbar = new TextEditingController();
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
                locationData.searchProdcutSeller(value);
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
                                    SellerProductSearchDetailsScreen(
                                        txt_searchbar.text)));
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
                      locationData.psearchResults![index].productname
                          .toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SellerProductSearchDetailsScreen(locationData
                                      .psearchResults![index].productname
                                      .toString())));
                      //exit(0);
                    },
                  );
                })
            : SizedBox());
  }
}

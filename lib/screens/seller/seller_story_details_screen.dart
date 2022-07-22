import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class SellerStoryDetailsScreen extends StatefulWidget {
  const SellerStoryDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SellerStoryDetailsScreen> createState() =>
      _SellerStoryDetailsScreenState();
}

class _SellerStoryDetailsScreenState extends State<SellerStoryDetailsScreen> {
  List story = [];
  final controller = StoryController();
  List<StoryItem> storyItems = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoryByUserId();
  }

  void getStoryByUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? userid = preferences.getString("userid");
    var nencoded = Uri.parse(
        get_story_by_userid + preferences.getString("userid").toString());
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          story = mnjson["data"]["storybyeuserid"];
        });
        for (int i = 0; i < story.length; i++) {
          if (DateTime.parse(
                  mnjson["data"]["storybyeuserid"][i]["publishedon"].toString())
              .add(Duration(hours: 24))
              .isAfter(DateTime.now())) {
            print(
                "image    image    image    image    image    image    image    ");

            print(baseUrl + story[i]["image"]);
            setState(() {
              storyItems.add(StoryItem.pageImage(
                  url: baseUrl + story[i]["image"],
                  controller: controller,
                  caption: story[i]["text"]));
            });
          }
        }
      }
    });
  }

  String storename = "";
  String imageUrl = "";
  String address = "";
  double lat = 0;
  double lang = 0;
  String mobileNo = "";
  String categoryId = "";
  bool? follewed;
  void getSellerDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var nencoded = Uri.parse(
        get_sellerdetalsbyuserid + preferences.getString("userid").toString());
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        if (mnjson["Data"]["Seller"].length > 0) {
          setState(() {
            storename = mnjson["Data"]["Seller"][0]["businessname"];
            imageUrl = baseUrl + mnjson["Data"]["Seller"][0]["photo"];
            address = mnjson["Data"]["Seller"][0]["streetaddress"];
            lat = mnjson["Data"]["Seller"][0]["latitude"];
            lang = mnjson["Data"]["Seller"][0]["longitude"];
            mobileNo = mnjson["Data"]["Seller"][0]["businesscontactinfo"];
            categoryId = mnjson["Data"]["Seller"][0]["businesscatagories"];
          });
          //   getRattings();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.length > 0
          ? Stack(
              children: [
                StoryView(
                  storyItems: storyItems,
                  controller: controller,
                  inline: true,
                  repeat: true,
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 60, left: 20),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: NetworkImage(baseUrl + imageUrl),
                              fit: BoxFit.cover)),
                    )),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

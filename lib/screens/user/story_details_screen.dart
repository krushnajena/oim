import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryDetailsScreen extends StatefulWidget {
  final String storeid;
  final String storename;
  final String storeimage;
  StoryDetailsScreen(this.storeid, this.storename, this.storeimage);

  @override
  State<StoryDetailsScreen> createState() => _StoryDetailsScreenState();
}

class _StoryDetailsScreenState extends State<StoryDetailsScreen> {
  List story = [];
  final controller = StoryController();
  List<StoryItem> storyItems = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoryByUserId();
  }

  void addView(Key? id) {
    var nencoded = Uri.parse(postview);
    print("keyyyyyyyyy");
    String string = id.toString();

    string = string.replaceAll("[<'", '');
    string = string.replaceAll("'>]", '');
    print(string);
    print("keyyyyyyyyy");
    print("sssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
    http.post(nencoded, body: {
      "cid": string,
      "userid": widget.storeid,
      "type": "story"
    }).then((value) {
      print("-----------------------------");
      print(value.statusCode);
      if (value.statusCode == 200) {}
    });
  }

  void getStoryByUserId() async {
    String? userid = widget.storeid;
    var nencoded = Uri.parse(get_story_by_userid + userid);
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
                  key: Key(story[i]["_id"]),
                  url: baseUrl + story[i]["image"],
                  controller: controller,
                  caption: story[i]["text"]));
            });
          }
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
                  repeat: false,
                  onStoryShow: (value) {
                    addView(value.view.key);
                  },
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 60, left: 20),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: NetworkImage(baseUrl + widget.storeimage),
                              fit: BoxFit.cover)),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 65, left: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.storename,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

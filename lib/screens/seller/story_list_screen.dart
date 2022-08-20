import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/camera.dart';
import 'package:oim/screens/seller/seller_story_details_screen.dart';
import 'package:oim/screens/seller/story_create_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class StoryListScreen extends StatefulWidget {
  const StoryListScreen({Key? key}) : super(key: key);

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  List story = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoryByUserId();
  }

  void deleteStory(String id) {
    print("Story Delete");
    var nencoded = Uri.parse(getDeleteStory + id!);
    print("Story Delete");
    print(getDeleteStory + id!);
    print("Story Delete");
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        getStoryByUserId();
      }
    });
  }

  void getStoryByUserId() async {
    setState(() {
      story = [];
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userid = preferences.getString("userid");
    var nencoded = Uri.parse(get_story_by_userid + userid!);
    print(get_story_by_userid + userid!);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);

        print(mnjson["data"]["storybyeuserid"]);
        for (int i = 0; i < mnjson["data"]["storybyeuserid"].length; i++) {
          if (DateTime.parse(mnjson["data"]["storybyeuserid"][i]["publishedon"]
                      .toString())
                  .add(Duration(hours: 24))
                  .isAfter(DateTime.now()) &&
              mnjson["data"]["storybyeuserid"][i]["isdeleted"] == false) {
            print("89890809****************))))))))))))");
            print(mnjson["data"]["storybyeuserid"][i]);
            setState(() {
              story.add(mnjson["data"]["storybyeuserid"][i]);
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 10.0),
        backgroundColor: Colors.blue,
        elevation: 0.1,
        centerTitle: true,
        title: Text("Stories"),
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      List<CameraDescription> cameras;
                      cameras = await availableCameras();
                      print("*************(())())");
                      print(cameras.length);
                      print("*************(())())");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryCreateScreen()));
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Stories',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SellerStoryDetailsScreen()));
                            },
                            child: Card(
                              color: Colors.transparent,
                              elevation: 10,
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              baseUrl + story[index]["image"]),
                                          fit: BoxFit.cover)),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomRight,
                                                stops: [
                                                  0.1,
                                                  1
                                                ],
                                                colors: [
                                                  Colors.black.withOpacity(.8),
                                                  Colors.black.withOpacity(.1)
                                                ])),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, top: 180),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            Text(
                                              "Views : 0",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PopupMenuButton(
                                    color: Colors.white,
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                            child: Text("Remove Story"),
                                            value: 2,
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      CupertinoAlertDialog(
                                                        title: new Text(
                                                            "Confirmation"),
                                                        content: new Text(
                                                            "Do you want to delete "),
                                                        actions: <Widget>[
                                                          CupertinoDialogAction(
                                                            isDefaultAction:
                                                                true,
                                                            child: Text(
                                                                "Delete Story"),
                                                            onPressed:
                                                                () async {
                                                              deleteStory(story[
                                                                          index]
                                                                      ["_id"]
                                                                  .toString());
                                                            },
                                                          ),
                                                          CupertinoDialogAction(
                                                            child: Text("Exit"),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          )
                                                        ],
                                                      ));

                                              //getRemoveItem(products[index]["_id"]
                                              //    .toString());
                                            },
                                          )
                                        ]),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: story.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 220,
                  ),
                ),
                SliverGrid.extent(
                  maxCrossAxisExtent: 250,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 2.5,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

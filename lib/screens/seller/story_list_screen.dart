import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
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
        backgroundColor: Colors.white,
        elevation: 0.1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 250.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 45.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: DecorationImage(
                      image: AssetImage("images/photo1.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Stories",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => StoryCreateScreen()));
        },
        isExtended: true,
        backgroundColor: Colors.orange[800],
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          "Add Story",
          style: TextStyle(fontSize: 19, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
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
                                            left: 8, right: 8, top: 160),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            Text(
                                              " Views : 0",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: InkWell(
                              onTap: () {
                                print(story[index]);
                                deleteStory(story[index]["_id"].toString());
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(150),
                                ),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
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

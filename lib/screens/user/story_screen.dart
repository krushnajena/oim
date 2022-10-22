import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/user/story_details_screen.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  List stores = [];
  bool isLoaded = false;
  void getStories() async {
    var nencoded = Uri.parse(get_stories_seller);
    print(nencoded);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);

        for (int i = 0; i < mnjson["data"]["seller"].length; i++) {
          if (mnjson["data"]["seller"][i]["stories"].length > 0) {
            for (int j = 0;
                j < mnjson["data"]["seller"][i]["stories"].length;
                j++) {
              if (DateTime.parse(mnjson["data"]["seller"][i]["stories"][j]
                              ["publishedon"]
                          .toString())
                      .add(Duration(hours: 24))
                      .isAfter(DateTime.now()) &&
                  mnjson["data"]["seller"][i]["stories"][j]["isdeleted"] ==
                      false) {
                setState(() {
                  stores.add(mnjson["data"]["seller"][i]);
                });
                break;
              }
            }
            setState(() {
              isLoaded = true;
            });
            print(stores);
          }
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Stories"),
      ),
      body: stores.length != 0 && isLoaded == true
          ? CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return stores[index]["stories"].length > 0
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StoryDetailsScreen(
                                                stores[index]["userid"],
                                                stores[index]["businessname"],
                                                stores[index]["photo"])));
                              },
                              child: Card(
                                color: Colors.transparent,
                                elevation: 10,
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(baseUrl +
                                                stores[index]["stories"][0]
                                                    ["image"]),
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
                                                    Colors.black
                                                        .withOpacity(.8),
                                                    Colors.black.withOpacity(.1)
                                                  ])),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8, top: 150),
                                          child: Text(
                                            stores[index]["businessname"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            )
                          : Center(
                              child: Image(
                              image: AssetImage("images/nostory.png"),
                              height: 200,
                            ));
                    },
                    childCount: stores.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 200,
                  ),
                ),
              ],
            )
          : Center(
              child: Image(
              image: AssetImage("images/nostory.png"),
              height: 200,
            )),
    );
  }
}

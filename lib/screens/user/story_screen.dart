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
  void getStories() async {
    var nencoded = Uri.parse(get_stories_seller);

    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        setState(() {
          stores = mnjson["data"]["seller"];
        });
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
      body: CustomScrollView(
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
                                  builder: (context) => StoryDetailsScreen(
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
                                      image: NetworkImage(
                                          baseUrl + stores[index]["photo"]),
                                      fit: BoxFit.cover)),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                    : SizedBox();
              },
              childCount: stores.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              mainAxisExtent: 200,
            ),
          ),
        ],
      ),
    );
  }
}

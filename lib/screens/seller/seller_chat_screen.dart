import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/helpers/database.dart';
import 'package:oim/models/chat_model.dart';
import 'package:oim/resources/firebase_repository.dart';
import 'package:oim/screens/seller/seller_chat_message_screen.dart';
import 'package:oim/screens/widgets/custom_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SellerChatScreen extends StatefulWidget {
  const SellerChatScreen({Key? key}) : super(key: key);

  @override
  State<SellerChatScreen> createState() => _SellerChatScreenState();
}

class _SellerChatScreenState extends State<SellerChatScreen> {
  late Stream chatMessageStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageEditingController = new TextEditingController();
  List<ChatModel> chats = [];
  ChatModel sourceChat = new ChatModel();

  ScrollController _listScrollController = ScrollController();

  Widget unreadmessgaList(String userid) {
    var beginningDate = DateTime.now();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("players")
            .where("sellerid", isEqualTo: userid)
            .where("isSellerUnred", isEqualTo: "1")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center();
          }

          return ListView.builder(
            padding: EdgeInsets.all(10),
            controller: _listScrollController,
            reverse: false,
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // mention the arrow syntax if you get the time
              return snapshot.data!.docs[index]["lastMessage"] !=
                      "NoMessageAvailableOimAppmaAgg"
                  ? snapshot.data!.docs[index]["isDeletdBySeller"] != "1"
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) =>
                                        SellerChatMessageScreen(
                                          snapshot.data!.docs[index].id
                                              .toString(),
                                          snapshot.data!.docs[index]["userid"]
                                              .toString(),
                                          snapshot.data!.docs[index]["sellerid"]
                                              .toString(),
                                          snapshot
                                              .data!.docs[index]["productid"]
                                              .toString(),
                                          snapshot.data!.docs[index]
                                              ["isBlockedByByer"],
                                          snapshot.data!.docs[index]
                                              ["isBlockedBySeller"],
                                        )));
                          },
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 10, top: 25),
                                  child: Row(
                                    children: [
                                      Stack(children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(baseUrl +
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                            ["productlogo"]
                                                        .toString()),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 45, top: 40),
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                              image: DecorationImage(
                                                  image: NetworkImage(baseUrl +
                                                      snapshot
                                                          .data!
                                                          .docs[index]
                                                              ["sellerlogo"]
                                                          .toString()),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ]),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  snapshot.data!
                                                      .docs[index]["username"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              snapshot.data!
                                                  .docs[index]["productname"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              snapshot.data!
                                                  .docs[index]["lastMessage"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete Chat'),
                                      onTap: () {
                                        FirebaseRepository _repository =
                                            FirebaseRepository();
                                        _repository.deleteMessage(
                                            snapshot.data!.docs[index].id
                                                .toString(),
                                            "seller");
                                      },
                                    ),
                                    snapshot.data!.docs[index]
                                                ["isDeletdBySeller"] !=
                                            "1"
                                        ? PopupMenuItem(
                                            value: 'block',
                                            child: Text('Block User'),
                                            onTap: () {
                                              FirebaseRepository _repository =
                                                  FirebaseRepository();
                                              _repository.blockMessage(
                                                  snapshot.data!.docs[index].id
                                                      .toString(),
                                                  "seller");
                                            },
                                          )
                                        : PopupMenuItem(
                                            value: 'unblock',
                                            child: Text('UnBlock User'),
                                            onTap: () {
                                              FirebaseRepository _repository =
                                                  FirebaseRepository();
                                              _repository.unblockMessage(
                                                  snapshot.data!.docs[index].id
                                                      .toString(),
                                                  "seller");
                                            },
                                          )
                                  ];
                                },
                                onSelected: (String value) {
                                  print('You Click on po up menu item');
                                },
                              ),
                            ),
                          ]),
                        )
                      : SizedBox()
                  : SizedBox();
            },
          );
        });
  }

  Widget messgaList(String userid) {
    var beginningDate = DateTime.now();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("players")
            .where("sellerid", isEqualTo: userid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center();
          }

          return ListView.builder(
            padding: EdgeInsets.all(10),
            controller: _listScrollController,
            reverse: false,
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // mention the arrow syntax if you get the time
              return snapshot.data!.docs[index]["lastMessage"] !=
                      "NoMessageAvailableOimAppmaAgg"
                  ? snapshot.data!.docs[index]["isDeletdBySeller"] != "1"
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) =>
                                        SellerChatMessageScreen(
                                          snapshot.data!.docs[index].id
                                              .toString(),
                                          snapshot.data!.docs[index]["userid"]
                                              .toString(),
                                          snapshot.data!.docs[index]["sellerid"]
                                              .toString(),
                                          snapshot
                                              .data!.docs[index]["productid"]
                                              .toString(),
                                          snapshot.data!.docs[index]
                                              ["isBlockedByByer"],
                                          snapshot.data!.docs[index]
                                              ["isBlockedBySeller"],
                                        )));
                          },
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 10, top: 25),
                                  child: Row(
                                    children: [
                                      Stack(children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(baseUrl +
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                            ["productlogo"]
                                                        .toString()),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 45, top: 40),
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                              image: DecorationImage(
                                                  image: NetworkImage(baseUrl +
                                                      snapshot
                                                          .data!
                                                          .docs[index]
                                                              ["sellerlogo"]
                                                          .toString()),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                      ]),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  snapshot.data!
                                                      .docs[index]["username"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              snapshot.data!
                                                  .docs[index]["productname"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              snapshot.data!
                                                  .docs[index]["lastMessage"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete Chat'),
                                      onTap: () {
                                        FirebaseRepository _repository =
                                            FirebaseRepository();
                                        _repository.deleteMessage(
                                            snapshot.data!.docs[index].id
                                                .toString(),
                                            "seller");
                                      },
                                    ),
                                    snapshot.data!.docs[index]
                                                ["isDeletdBySeller"] !=
                                            "1"
                                        ? PopupMenuItem(
                                            value: 'block',
                                            child: Text('Block User'),
                                            onTap: () {
                                              FirebaseRepository _repository =
                                                  FirebaseRepository();
                                              _repository.blockMessage(
                                                  snapshot.data!.docs[index].id
                                                      .toString(),
                                                  "seller");
                                            },
                                          )
                                        : PopupMenuItem(
                                            value: 'unblock',
                                            child: Text('UnBlock User'),
                                            onTap: () {
                                              FirebaseRepository _repository =
                                                  FirebaseRepository();
                                              _repository.unblockMessage(
                                                  snapshot.data!.docs[index].id
                                                      .toString(),
                                                  "seller");
                                            },
                                          )
                                  ];
                                },
                                onSelected: (String value) {
                                  print('You Click on po up menu item');
                                },
                              ),
                            ),
                          ]),
                        )
                      : SizedBox()
                  : SizedBox();
            },
          );
        });
  }

  String user = "";
  void getUserDetils() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user = preferences.getString("userid").toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetils();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: 660,
          width: double.infinity,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 10,
                elevation: 1,
                backgroundColor: Colors.white,
                bottom: TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "ALL",
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "UNREAD",
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(children: [
                user != "" ? messgaList(user) : SizedBox(),
                user != "" ? unreadmessgaList(user) : SizedBox(),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

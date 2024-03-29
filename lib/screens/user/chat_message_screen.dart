import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/models/chat_model.dart';

import 'package:oim/models/message_model.dart';

import 'package:flutter/material.dart';
import 'package:oim/resources/firebase_repository.dart';
import 'package:oim/screens/user/product_details_screen.dart';
import 'package:oim/screens/user/select_image_for_chat_screen.dart';
import 'package:oim/screens/user/store_details_screen.dart';
import 'package:oim/screens/widgets/own_message_card.dart';
import 'package:oim/screens/widgets/reply_message_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ChatMessage_Screen extends StatefulWidget {
  const ChatMessage_Screen(this.id, this.userid, this.sellerid, this.productid,
      this.isUserBlocked, this.isSellerBlocked);

  final String id, userid, sellerid, productid, isUserBlocked, isSellerBlocked;

  @override
  State<ChatMessage_Screen> createState() => _ChatMessage_ScreenState();
}

class _ChatMessage_ScreenState extends State<ChatMessage_Screen> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String sellerName = "";
  String sellerImage = "";
  String productName = "";
  String productPrice = "";
  String productImage = "";
  String sellerPhoneNo = "";
  Future<void> validate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> result = await firestore
        .collection("players")
        .where("productid", isEqualTo: widget.productid)
        .where("sellerid", isEqualTo: widget.sellerid)
        .where("userid", isEqualTo: preferences.getString("userid"))
        .get();

    if (result.docs.length == 0) {
    } else {
      setState(() {
        productName = result.docs[0]["productname"].toString();
        productImage = result.docs[0]["productlogo"].toString();
        productPrice = result.docs[0]["productprice"].toString();
      });
    }
  }

  ScrollController _listScrollController = ScrollController();
  updateReadFlag(String id, String source, String chatid) {
    FirebaseRepository _repository = FirebaseRepository();
    print("aaaaaaaasdfdghjjjjjjjjjjjjjjjjjjjjjj" + id);
    _repository.updateReadMsgFlag(id, source, chatid);
  }

  Widget messgaList() {
    FirebaseRepository _repository = FirebaseRepository();
    var beginningDate = DateTime.now();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("message")
            .where('msgid', isEqualTo: widget.id)
            .orderBy("messagedon", descending: false)
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
              print("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
              print(snapshot.data!.docs[index]["source"].toString());
              print(snapshot.data!.docs[index]["issRead"].toString());

              if (snapshot.data!.docs[index]["source"].toString() == "seller" &&
                  snapshot.data!.docs[index]["issRead"] == false) {
                print("aaaaaaaasdfdghjjjjjjjjjjjjjjjjjjjjjj");
                updateReadFlag(snapshot.data!.docs[index].id, "buyer",
                    snapshot.data!.docs[index]["msgid"].toString());
              }

              return snapshot.data!.docs[index]["source"].toString() == "buyer"
                  ? GestureDetector(
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                                  title: new Text("Confirmation"),
                                  content: new Text(
                                      "Do you want to Delete This Chat?"),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () async {
                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();
                                        preferences.clear();

                                        Navigator.of(context).pop();
                                        _repository.fulldeleteMessage(snapshot
                                            .data!.docs[index].id
                                            .toString());
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text(
                                        "Exit",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ));
                      },
                      child: OwnMessageCard(
                          message:
                              snapshot.data!.docs[index]["message"].toString(),
                          time: snapshot.data!.docs[index]["time"].toString(),
                          isRead: snapshot.data!.docs[index]["issRead"],
                          messageType: snapshot.data!.docs[index]["type"]),
                    )
                  : snapshot.data!.docs[index]["isBlockedByByer"].toString() !=
                          "1"
                      ? ReplyCard(
                          message:
                              snapshot.data!.docs[index]["message"].toString(),
                          time: snapshot.data!.docs[index]["time"].toString(),
                          messageType: snapshot.data!.docs[index]["type"])
                      : SizedBox();
            },
          );
        });
  }

  void getSellerDetails() async {
    var nencoded = Uri.parse(get_sellerdetalsbyuserid + widget.sellerid);
    print("seller id " + widget.userid);
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        if (mnjson["Data"]["Seller"].length > 0) {
          setState(() {
            sellerName = mnjson["Data"]["Seller"][0]["businessname"];
            sellerImage = baseUrl + mnjson["Data"]["Seller"][0]["photo"];

            sellerPhoneNo = mnjson["Data"]["Seller"][0]["businesscontactinfo"];
          });
        }
      }
    });
  }

  File? _pickedImage2;
  void _pickImage2(String from, String type) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      Navigator.of(context).pop();
      var a = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectImageForChatScreen(
                  File(pickedImageFile!.path.toString()))));
      if (a["send"] == "1") {
        setState(() {
          _pickedImage2 = File(pickedImageFile!.path.toString());
        });
        sendImageMessage();
      }
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      Navigator.of(context).pop();
      var a = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectImageForChatScreen(
                  File(pickedImageFile!.path.toString()))));
      if (a["send"] == "1") {
        setState(() {
          _pickedImage2 = File(pickedImageFile!.path.toString());
        });
        sendImageMessage();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    validate();
    getSellerDetails();
  }

  void sendMessage(String message, String sourceId, String targetId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    FirebaseRepository _repository = FirebaseRepository();
    DateTime todayDate = DateTime.now(); //DateTime
    print("dedddddddddddddddddddddddddddddddddddd");
    Timestamp todayDateTimeStamp = Timestamp.fromDate(todayDate);
    print("dedddddddddddddddddddddddddddddddddddd");
    MessageModel _players = MessageModel(
        type: "text",
        message: message,
        time: DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString(),
        from: preferences.getString("userid"),
        to: widget.sellerid,
        source: "buyer",
        messagedon: todayDateTimeStamp,
        msgid: widget.id,
        issRead: false,
        isBlockedByByer: widget.isUserBlocked,
        isBlockedBySeller: widget.isSellerBlocked);
    _repository.sendMessageDb(_players);
    print("dddddddddddddddddddddddddddddddd");
  }

  void sendImageMessage() async {
    if (_pickedImage2 != null) {
      final imageUploadRequest =
          http.MultipartRequest('POST', Uri.parse(postDcumentUploadForMessage));
      final mimeTypeData = lookupMimeType(_pickedImage2!.path.toString(),
              headerBytes: [0xFF, 0xD8])!
          .split('/');

      final file = await http.MultipartFile.fromPath(
          'image', _pickedImage2!.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
      imageUploadRequest.files.add(file);

      try {
        final streamedResponse = await imageUploadRequest.send();
        final response = await http.Response.fromStream(streamedResponse);
        print(response.body);
        print(response.statusCode);
        Map mnjson;
        mnjson = json.decode(response.body);
        if (response.statusCode == 200) {
          setState(() {
            _pickedImage2 = null;
          });

          SharedPreferences preferences = await SharedPreferences.getInstance();
          FirebaseRepository _repository = FirebaseRepository();
          DateTime todayDate = DateTime.now(); //DateTime
          print("dedddddddddddddddddddddddddddddddddddd");
          Timestamp todayDateTimeStamp = Timestamp.fromDate(todayDate);
          print("dedddddddddddddddddddddddddddddddddddd");
          String upimageurl = mnjson["data"]["upfilename"].toString();
          MessageModel _players = MessageModel(
              type: "image",
              message: upimageurl,
              time: DateTime.now().hour.toString() +
                  ":" +
                  DateTime.now().minute.toString(),
              from: preferences.getString("userid"),
              to: widget.sellerid,
              source: "buyer",
              messagedon: todayDateTimeStamp,
              msgid: widget.id,
              issRead: false,
              isBlockedByByer: widget.isUserBlocked,
              isBlockedBySeller: widget.isSellerBlocked);
          _repository.sendMessageDb(_players);
          print("dddddddddddddddddddddddddddddddd");
        }
      } catch (e) {
        print(e);
        Navigator.of(context).pop();
      }
    }
  }

  void setMessage(String type, String message) {
    MessageModel messageModel = MessageModel(
        type: type,
        message: message,
        time: DateTime.now().toString().substring(10, 16));
    print(messages);

    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/whatsapp_Back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    CircleAvatar(
                      child: Image.network(
                        baseUrl + sellerImage,
                        color: Colors.white,
                        height: 36,
                        width: 36,
                      ),
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StoreDetailsScreen(widget.sellerid)));
                },
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        sellerName,
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.call),
                    onPressed: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: sellerPhoneNo,
                      );
                      await launchUrl(launchUri);
                    }),
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bg2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: WillPopScope(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsScreen(widget.productid)));
                        },
                        child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            baseUrl + productImage),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.redAccent,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        productName,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      "₹" + productPrice,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      // height: MediaQuery.of(context).size.height - 150,
                      child: messgaList()),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: TextFormField(
                                      controller: _controller,
                                      focusNode: focusNode,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 5,
                                      minLines: 1,
                                      onChanged: (value) {
                                        if (value.length > 0) {
                                          setState(() {
                                            sendButton = true;
                                          });
                                        } else {
                                          setState(() {
                                            sendButton = false;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Type a message",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.attach_file),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    builder: (builder) =>
                                                        bottomSheet());
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.camera_alt),
                                              onPressed: () {
                                                _pickImage2("camera", "");
                                              },
                                            ),
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.all(5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  right: 2,
                                  left: 2,
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blue,
                                  child: IconButton(
                                    icon: Icon(
                                      sendButton ? Icons.send : Icons.send,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (_controller.text != "") {
                                        sendMessage(_controller.text, "", "");

                                        _controller.clear();
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 185,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        print("ff");
                        _pickImage2("camera", "");
                      },
                      child: iconCreation(
                          Icons.camera_alt, Colors.pink, "Camera")),
                  SizedBox(
                    width: 40,
                  ),
                  InkWell(
                      onTap: () {
                        _pickImage2("gallery", "");
                      },
                      child: iconCreation(
                          Icons.insert_photo, Colors.purple, "Gallery")),
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(
            icons,
            // semanticLabel: "Help",
            size: 29,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            // fontWeight: FontWeight.w100,
          ),
        )
      ],
    );
  }
}

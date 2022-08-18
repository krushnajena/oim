import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/products_list_screen.dart';
import 'package:oim/screens/widgets/imagesilder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResturentSettingScreen extends StatefulWidget {
  const ResturentSettingScreen({Key? key}) : super(key: key);

  @override
  State<ResturentSettingScreen> createState() => _ResturentSettingScreenState();
}

class _ResturentSettingScreenState extends State<ResturentSettingScreen> {
  List<Widget> images = [];
  List food = [];
  List amb = [];
  List img = [];
  bool isImageSliderLoaded = false;
  File? _pickedImage2;
  String selectedItem = "food";

  TextEditingController txt_name = new TextEditingController();
  void _pickImage2(String from, String type) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage2 = File(pickedImageFile!.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedImage2 = File(pickedImageFile!.path.toString());
      });
    }
    if (type == "banner") {
      save();
    }
  }

  void save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse(postrestaurantimage));
    if (_pickedImage2 != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Wrap(
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      SpinKitRing(
                        color: primaryColor,
                        size: 40.0,
                        lineWidth: 1.2,
                      ),
                      SizedBox(height: 25.0),
                      Text(
                        'Please Wait..',
                        style: grey14MediumTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );

      final mimeTypeData = lookupMimeType(_pickedImage2!.path.toString(),
              headerBytes: [0xFF, 0xD8])!
          .split('/');

      final file = await http.MultipartFile.fromPath(
          'image', _pickedImage2!.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
      imageUploadRequest.files.add(file);
      imageUploadRequest.fields['sellerid'] =
          preferences.getString("userid").toString();
      imageUploadRequest.fields['type'] = selectedItem;
      if (selectedItem == "banner") {
        imageUploadRequest.fields['name'] = selectedItem;
      } else {
        imageUploadRequest.fields['name'] = txt_name.text;
      }
      try {
        final streamedResponse = await imageUploadRequest.send();
        final response = await http.Response.fromStream(streamedResponse);
        print(response.body);
        print(response.statusCode);
        Map mnjson;
        mnjson = json.decode(response.body);
        if (response.statusCode == 200) {
          if (selectedItem != "banner") {
            Navigator.of(context).pop();
          }

          Navigator.of(context).pop();
          setState(() {
            _pickedImage2 = null;
          });
          getImageSlider();
        }
      } catch (e) {
        print(e);
        Navigator.of(context).pop();
      }
    }
  }

  getImageSlider() async {
    setState(() {
      images = [];
      food = [];
      amb = [];
      img = [];
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var encoded = Uri.parse(getRestaurentImageBySellerId +
        preferences.getString("userid").toString());
    print(get_image_banner);
    http.get(encoded).then((value) async {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson);

        for (int i = 0; i < mjson["data"]["sellerimages"].length; i++) {
          if (mjson["data"]["sellerimages"][i]["type"] == "banner") {
            setState(() {
              images.add(Image.network(
                  baseUrl + mjson["data"]["sellerimages"][i]["image"],
                  fit: BoxFit.fill));
            });
          }

          if (mjson["data"]["sellerimages"][i]["type"] == "food") {
            setState(() {
              food.add(
                mjson["data"]["sellerimages"][i]["image"],
              );
            });
          }
          if (mjson["data"]["sellerimages"][i]["type"] == "ambience") {
            setState(() {
              amb.add(
                mjson["data"]["sellerimages"][i]["image"],
              );
            });
          }
          if (mjson["data"]["sellerimages"][i]["type"] == "menu") {
            setState(() {
              img.add(
                mjson["data"]["sellerimages"][i]["image"],
              );
            });
          }
        }
        setState(() {
          isImageSliderLoaded = true;
        });
      }
    }).catchError((onError) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Image"),
        centerTitle: true,
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
                    onPressed: () {
                      if (selectedItem == "banner") {
                        setState(() {
                          selectedItem = "food";
                        });
                      }
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Add Image",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: TextField(
                                    controller: txt_name,
                                    onTap: () {},
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      hintStyle: const TextStyle(
                                          color: Colors.black38),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: new Icon(Icons.photo),
                                  title: new Text('Gallery'),
                                  onTap: () {
                                    _pickImage2("gallery", selectedItem);
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(Icons.videocam),
                                  title: new Text('Camera'),
                                  onTap: () {
                                    _pickImage2("camera", selectedItem);
                                  },
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    save();
                                  },
                                  child: Text("Add"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          });
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Image',
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
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              delegate: SliverAppBarDelegate(
            minHeight: 275,
            maxHeight: 275,
            child: Column(
              children: [
                ImageSlideshow(
                  width: double.infinity,
                  height: 200,
                  initialPage: 0,
                  indicatorColor: Colors.blue,
                  indicatorBackgroundColor: Colors.grey,
                  children: images,
                  isLoop: false,
                ),
                //   ImagesCarousel(imageSlider),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedItem = "banner";
                        });
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: new Icon(Icons.photo),
                                    title: new Text('Gallery'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _pickImage2("gallery", "banner");
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.videocam),
                                    title: new Text('Camera'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _pickImage2("camera", "banner");
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                            child: Text(
                          "Add Banner Image",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey[30],
                ),
              ],
            ),
          )),
          SliverPersistentHeader(
              delegate: SliverAppBarDelegate(
                  minHeight: 30,
                  maxHeight: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                          child: Text("Food (" + food.length.toString() + ")",
                              style: TextStyle(
                                  color: selectedItem == "food" || selectedItem == "banner"
                                      ? Colors.white
                                      : Colors.blue)),
                          onPressed: () {
                            setState(() {
                              selectedItem = "food";
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: selectedItem == "food" || selectedItem == "banner"
                                  ? MaterialStateProperty.all<Color>(
                                      Colors.blue)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: selectedItem == "food" ||
                                                  selectedItem == "banner"
                                              ? Colors.white
                                              : Colors.blue))))),
                      ElevatedButton(
                          child: Text(
                              "Ambience (" + amb.length.toString() + ")",
                              style: TextStyle(
                                  color: selectedItem == "ambience"
                                      ? Colors.white
                                      : Colors.blue)),
                          onPressed: () {
                            setState(() {
                              selectedItem = "ambience";
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: selectedItem == "ambience"
                                  ? MaterialStateProperty.all<Color>(
                                      Colors.blue)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: selectedItem == "ambience"
                                              ? Colors.white
                                              : Colors.blue))))),
                      ElevatedButton(
                          child: Text("Menu (" + img.length.toString() + ")",
                              style: TextStyle(
                                  color: selectedItem == "menu"
                                      ? Colors.white
                                      : Colors.blue)),
                          onPressed: () {
                            setState(() {
                              selectedItem = "menu";
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: selectedItem == "menu"
                                  ? MaterialStateProperty.all<Color>(
                                      Colors.blue)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: selectedItem == "menu"
                                              ? Colors.white
                                              : Colors.blue))))),
                    ],
                  ))),
          selectedItem == "food" || selectedItem == "banner"
              ? SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 150,
                          width: 170,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          baseUrl + food[index],
                                        )),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: food.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 3,
                    mainAxisExtent: 170,
                  ),
                )
              : selectedItem == "ambience"
                  ? SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: SizedBox(
                              height: 150,
                              width: 170,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              baseUrl + amb[index],
                                            )),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: amb.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 3,
                        mainAxisExtent: 170,
                      ),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: SizedBox(
                              height: 150,
                              width: 170,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              baseUrl + img[index],
                                            )),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: img.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 3,
                        mainAxisExtent: 170,
                      ),
                    )
        ],
      ),
    );
  }
}

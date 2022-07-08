import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StoryCreateScreen extends StatefulWidget {
  const StoryCreateScreen({Key? key}) : super(key: key);

  @override
  State<StoryCreateScreen> createState() => _StoryCreateScreenState();
}

class _StoryCreateScreenState extends State<StoryCreateScreen> {
  List<File> images = [];
  File? _pickedImage1;
  TextEditingController txt_text = new TextEditingController();
  void _pickImage1(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        images.add(File(pickedImageFile!.path.toString()));
        // _pickedImage1 = File(pickedImageFile!.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        images.add(File(pickedImageFile!.path.toString()));
        //_pickedImage1 = File(pickedImageFile!.path.toString());
      });
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void postStory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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

    for (int i = 0; i < images.length; i++) {
      String? userid = preferences.getString("userid");
      final mimeTypeData =
          lookupMimeType(images[i].path.toString(), headerBytes: [0xFF, 0xD8])!
              .split('/');
      final imageUploadRequest =
          http.MultipartRequest('POST', Uri.parse(post_story_create));
      final file = await http.MultipartFile.fromPath('image', images[i].path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
      imageUploadRequest.files.add(file);
      imageUploadRequest.fields['userid'] = userid.toString();
      imageUploadRequest.fields['text'] = txt_text.text;

      try {
        final streamedResponse = await imageUploadRequest.send();
        final response = await http.Response.fromStream(streamedResponse);
        print(response.statusCode);

        if (response.statusCode == 200) {}
      } catch (e) {
        print(e);
      }
    }
    showInSnackBar("Your Story Posted Successfully");

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Story"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                height: 200,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                    child: Image.file(
                                  File(images[index].path.toString()),
                                )),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  images.removeAt(index);
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
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
                        ],
                      );
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: _pickedImage1 == null
                    ? InkWell(
                        onTap: () {
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
                                        _pickImage1("gallery");
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.videocam),
                                      title: new Text('Camera'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage1("camera");
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                              child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.grey,
                          )),
                        ),
                      )
                    : InkWell(
                        onTap: () {},
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                              child: Image.file(
                            File(_pickedImage1!.path.toString()),
                          )),
                        ),
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: txt_text,
                decoration: InputDecoration(
                    label: Row(
                      children: [
                        Text("Caption "),
                      ],
                    ),
                    labelStyle: TextStyle(color: Colors.black38),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    border: UnderlineInputBorder()),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      postStory();
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

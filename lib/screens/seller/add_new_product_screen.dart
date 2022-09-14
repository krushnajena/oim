import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/select_category_screen.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({Key? key}) : super(key: key);

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  String selectedUnit = "piece";
  //String _initialValue;
  String _valueChanged = '';
  String categoryname = '';
  String catelogName = '';
  String _valueToValidate = '';
  String _valueSaved = '';
  File? _pickedImage1;
  File? _pickedImage2;
  File? _pickedImage3;
  File? _pickedImage4;
  File? _pickedImage5;
  File? _pickedImage6;
  File? _pickedImage7;
  List<Map<String, String>> specifications = [];
  TextEditingController txt_productname = new TextEditingController();
  TextEditingController txt_mrp = new TextEditingController();
  TextEditingController txt_discountedprice = new TextEditingController();
  TextEditingController txt_productdetails = new TextEditingController();

  TextEditingController txt_key = new TextEditingController();
  TextEditingController txt_value = new TextEditingController();

  void add() {
    setState(() {
      specifications.add({"key": txt_key.text, "value": txt_value.text});
    });
  }

  final List<Map<String, dynamic>> _items = [];
  TextEditingController? _controller;
  void getCategories() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? categoryId = preferences.getString("businesscategory");
    var nencoded = Uri.parse(get_catelogues + categoryId!);
    print(get_catelogues + categoryId);
    http.get(nencoded).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson);
        for (int i = 0; i < mjson["data"]["catlog"].length; i++) {
          setState(() {
            _items.add(
              {
                'value': mjson["data"]["catlog"][i]["_id"],
                'label': mjson["data"]["catlog"][i]["cataloguename"],
              },
            );
          });
        }
      }
    });
  }

  void _pickImage1(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage1 = File(pickedImageFile!.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedImage1 = File(pickedImageFile!.path.toString());
      });
    }
  }

  void _pickImage2(String from) async {
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
  }

  void _pickImage3(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage3 = File(pickedImageFile!.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedImage3 = File(pickedImageFile!.path.toString());
      });
    }
  }

  void _pickImage4(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage4 = File(pickedImageFile!.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedImage4 = File(pickedImageFile!.path.toString());
      });
    }
  }

  void _pickImage5(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage5 = File(pickedImageFile!.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedImage5 = File(pickedImageFile!.path.toString());
      });
    }
  }

  void _pickImage6(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage6 = File(pickedImageFile!.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedImage6 = File(pickedImageFile!.path.toString());
      });
    }
  }

  void _pickImage7(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage7 = File(pickedImageFile!.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedImage7 = File(pickedImageFile!.path.toString());
      });
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void addProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (_pickedImage1 != null) {
      if (txt_productname.text != "") {
        if (txt_mrp.text != "") {
          if (txt_discountedprice.text != "") {
            if (_valueChanged != "") {
              if (txt_productdetails.text != "") {
                if (selectedUnit != "") {
                  try {
                    double mrp = double.parse(txt_mrp.text);
                    try {
                      double discounted =
                          double.parse(txt_discountedprice.text);
                      if (discounted < mrp) {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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

                        var speci = [];
                        final imageUploadRequest = http.MultipartRequest(
                            'POST', Uri.parse(post_add_product));
                        if (_pickedImage1 != null) {
                          final mimeTypeData = lookupMimeType(
                                  _pickedImage1!.path.toString(),
                                  headerBytes: [0xFF, 0xD8])!
                              .split('/');

                          final file = await http.MultipartFile.fromPath(
                              'image', _pickedImage1!.path,
                              contentType:
                                  MediaType(mimeTypeData[0], mimeTypeData[1]));
                          imageUploadRequest.files.add(file);
                        }
                        if (_pickedImage2 != null) {
                          final mimeTypeData = lookupMimeType(
                                  _pickedImage2!.path.toString(),
                                  headerBytes: [0xFF, 0xD8])!
                              .split('/');

                          final file = await http.MultipartFile.fromPath(
                              'image', _pickedImage2!.path,
                              contentType:
                                  MediaType(mimeTypeData[0], mimeTypeData[1]));
                          imageUploadRequest.files.add(file);
                        }
                        if (_pickedImage3 != null) {
                          final mimeTypeData = lookupMimeType(
                                  _pickedImage3!.path.toString(),
                                  headerBytes: [0xFF, 0xD8])!
                              .split('/');

                          final file = await http.MultipartFile.fromPath(
                              'image', _pickedImage3!.path,
                              contentType:
                                  MediaType(mimeTypeData[0], mimeTypeData[1]));
                          imageUploadRequest.files.add(file);
                        }
                        if (_pickedImage4 != null) {
                          final mimeTypeData = lookupMimeType(
                                  _pickedImage4!.path.toString(),
                                  headerBytes: [0xFF, 0xD8])!
                              .split('/');

                          final file = await http.MultipartFile.fromPath(
                              'image', _pickedImage4!.path,
                              contentType:
                                  MediaType(mimeTypeData[0], mimeTypeData[1]));
                          imageUploadRequest.files.add(file);
                        }
                        if (_pickedImage5 != null) {
                          final mimeTypeData = lookupMimeType(
                                  _pickedImage5!.path.toString(),
                                  headerBytes: [0xFF, 0xD8])!
                              .split('/');

                          final file = await http.MultipartFile.fromPath(
                              'image', _pickedImage5!.path,
                              contentType:
                                  MediaType(mimeTypeData[0], mimeTypeData[1]));
                          imageUploadRequest.files.add(file);
                        }

                        if (_pickedImage6 != null) {
                          final mimeTypeData = lookupMimeType(
                                  _pickedImage6!.path.toString(),
                                  headerBytes: [0xFF, 0xD8])!
                              .split('/');

                          final file = await http.MultipartFile.fromPath(
                              'image', _pickedImage6!.path,
                              contentType:
                                  MediaType(mimeTypeData[0], mimeTypeData[1]));
                          imageUploadRequest.files.add(file);
                        }
                        if (_pickedImage7 != null) {
                          final mimeTypeData = lookupMimeType(
                                  _pickedImage7!.path.toString(),
                                  headerBytes: [0xFF, 0xD8])!
                              .split('/');

                          final file = await http.MultipartFile.fromPath(
                              'image', _pickedImage7!.path,
                              contentType:
                                  MediaType(mimeTypeData[0], mimeTypeData[1]));
                          imageUploadRequest.files.add(file);
                        }
                        imageUploadRequest.fields['productname'] =
                            txt_productname.text;
                        imageUploadRequest.fields['instock'] = "1";
                        imageUploadRequest.fields['productunit'] = selectedUnit;

                        imageUploadRequest.fields['catalogueid'] =
                            _valueChanged;

                        imageUploadRequest.fields['productcategoryid'] =
                            preferences.getString("businesscategory")!;

                        imageUploadRequest.fields['mrp'] = txt_mrp.text;

                        imageUploadRequest.fields['sellingprice'] =
                            txt_discountedprice.text;

                        imageUploadRequest.fields['productdetails'] =
                            txt_productdetails.text;
                        imageUploadRequest.fields['sellerid'] =
                            preferences.getString("userid")!;
                        imageUploadRequest.fields['views'] = "0";
                        imageUploadRequest.fields['sepecification'] =
                            jsonEncode(specifications);
                        try {
                          final streamedResponse =
                              await imageUploadRequest.send();
                          final response =
                              await http.Response.fromStream(streamedResponse);
                          print(response.body);
                          print(response.statusCode);
                          Map mnjson;
                          mnjson = json.decode(response.body);
                          if (response.statusCode == 200) {
                            String productid = mnjson["data"]["product"]["_id"];

                            Navigator.of(context).pop();
                            showInSnackBar("Product Added Successfully");
                            setState(() {
                              _pickedImage1 = null;
                              _pickedImage2 = null;
                              _pickedImage3 = null;
                              _pickedImage4 = null;
                              _pickedImage5 = null;
                              _pickedImage6 = null;
                              _pickedImage7 = null;
                              txt_productname.text = "";
                              txt_mrp.text = "";
                              txt_discountedprice.text = "";
                              txt_productdetails.text = "";
                              specifications.clear();
                              txt_key.text = "";
                              txt_value.text = "";
                              _valueChanged = "";
                              selectedUnit = "";
                            });
                          }
                        } catch (e) {
                          print(e);
                          Navigator.of(context).pop();
                        }
                      } else {
                        showInSnackBar(
                            "Discounted Price Most Be Less Then MRP");
                      }
                    } catch (exr) {
                      showInSnackBar("Discounted Price Should be a number");
                    }
                  } catch (ex) {
                    showInSnackBar("Mrp Should be a number");
                  }
                } else {
                  showInSnackBar("Please Select Unit");
                }
              } else {
                showInSnackBar("Please Enter Product Details");
              }
            } else {
              showInSnackBar("Please Select Product Category");
            }
          } else {
            showInSnackBar("Please enter discounted price");
          }
        } else {
          showInSnackBar("Please enter Mrp");
        }
      } else {
        showInSnackBar("Please Enter Product Name");
      }
    } else {
      showInSnackBar("Please Select A Image");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Product"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,

                    child:
                    Align(
                      alignment: Alignment(-1.60, 0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          _pickedImage6 != null
                              ? _pickedImage7 == null
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
                                            _pickImage7("gallery");
                                          },
                                        ),
                                        ListTile(
                                          leading: new Icon(Icons.videocam),
                                          title: new Text('Camera'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickImage7("camera");
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: 100,
                              width: 100,
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
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                  child: Image.file(
                                    File(_pickedImage7!.path.toString()),
                                  )),
                            ),
                          )
                              : SizedBox(),
                          SizedBox(width: 10,),
                          _pickedImage5 != null
                              ? _pickedImage6 == null
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
                                            _pickImage6("gallery");
                                          },
                                        ),
                                        ListTile(
                                          leading: new Icon(Icons.videocam),
                                          title: new Text('Camera'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickImage6("camera");
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: 100,
                              width: 100,
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
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                  child: Image.file(
                                    File(_pickedImage6!.path.toString()),
                                  )),
                            ),
                          )
                              : SizedBox(),
                          SizedBox(
                            width: 10,
                          ),
                          _pickedImage4 != null
                              ? _pickedImage5 == null
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
                                            _pickImage5("gallery");
                                          },
                                        ),
                                        ListTile(
                                          leading: new Icon(Icons.videocam),
                                          title: new Text('Camera'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickImage5("camera");
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: 100,
                              width: 100,
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
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                  child: Image.file(
                                    File(_pickedImage5!.path.toString()),
                                  )),
                            ),
                          )
                              : SizedBox(),
                          SizedBox(
                            width: 10,
                          ),
                          _pickedImage3 != null
                              ? _pickedImage4 == null
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
                                            _pickImage4("gallery");
                                          },
                                        ),
                                        ListTile(
                                          leading: new Icon(Icons.videocam),
                                          title: new Text('Camera'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickImage4("camera");
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: 100,
                              width: 100,
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
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                  child: Image.file(
                                    File(_pickedImage4!.path.toString()),
                                  )),
                            ),
                          )
                              : SizedBox(),
                          SizedBox(
                            width: 10,
                          ),
                          _pickedImage2 != null
                              ? _pickedImage3 == null
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
                                            _pickImage3("gallery");
                                          },
                                        ),
                                        ListTile(
                                          leading: new Icon(Icons.videocam),
                                          title: new Text('Camera'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickImage3("camera");
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: 100,
                              width: 100,
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
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                  child: Image.file(
                                    File(_pickedImage3!.path.toString()),
                                  )),
                            ),
                          )
                              : SizedBox(),
                          SizedBox(width: 10,),
                          _pickedImage1 != null
                              ? _pickedImage2 == null
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
                                            _pickImage2("gallery");
                                          },
                                        ),
                                        ListTile(
                                          leading: new Icon(Icons.videocam),
                                          title: new Text('Camera'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _pickImage2("camera");
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                //color: Colors.grey,
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Stack(
                                children: [
                                  Text("Main Image"),
                                  Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                            ),
                          )
                              : InkWell(
                            onTap: () {},
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                  child: Image.file(
                                    File(_pickedImage2!.path.toString()),
                                  )),
                            ),
                          )
                              : SizedBox(),
                          SizedBox(width: 10,),

                          _pickedImage1 == null
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
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          )
                              : InkWell(
                            onTap: () {},
                            child: Container(
                              height: 100,
                              width: 100,
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
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text("You can add 7 images.",
                    style: TextStyle(color: Colors.black38, fontSize: 16),
                  ),
                  TextFormField(
                    controller: txt_productname,
                    decoration: InputDecoration(
                        label: Row(
                          children: [
                            Text("Product Name "),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
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
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 9.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    categoryname == ""
                                        ? "Select Category"
                                        : catelogName + '/' + categoryname,
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SelectCategoryScreen()));
                                        setState(() {
                                          categoryname = result["categoryname"];
                                          _valueChanged = result["categoryid"];
                                          catelogName = result["catelogName"];
                                        });
                                      },
                                      child: Icon(Icons.keyboard_arrow_down))
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  /*   Row(
                    children: [
                      RaisedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectCategoryScreen()));
                          setState(() {
                            categoryname = result["categoryname"];
                            _valueChanged = result["categoryid"];
                          });
                        },
                        child: Text("Select Category"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(categoryname,
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),*/
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: txt_mrp,
                          decoration: InputDecoration(
                              label: Row(
                                children: [
                                  Text('MRP '),
                                  Text(
                                    "*",
                                    style:
                                        TextStyle(color: Colors.red, fontSize: 20),
                                  ),
                                ],
                              ),
                              labelStyle: TextStyle(color: Colors.black38)),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          controller: txt_discountedprice,
                          onChanged: (value) {
                            if (txt_mrp.text == "") {
                              showInSnackBar("Please Enter Mrp");
                              txt_discountedprice.text = "";
                            } else {
                              double mrp = double.parse(txt_mrp.text);
                              double dis = double.parse(value);
                              if (dis > mrp) {
                                showInSnackBar(
                                    "Discounted Price Should Be less then MRP");
                                txt_discountedprice.text = "";
                                FocusScope.of(context).previousFocus();
                              }
                            }
                          },
                          decoration: InputDecoration(
                              label: Row(
                                children: [
                                  Text('Discounted Price '),
                                  Text(
                                    "*",
                                    style:
                                        TextStyle(color: Colors.red, fontSize: 20),
                                  ),
                                ],
                              ),
                              labelStyle: TextStyle(color: Colors.black38)),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 9.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedUnit == ""
                                        ? "Select Unit"
                                        : selectedUnit,
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(25.0),
                                                topRight:
                                                    const Radius.circular(25.0),
                                              ),
                                            ),
                                            context: context,
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 30,
                                                        left: 100,
                                                        bottom: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text(
                                                          "Choose Product Unit",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight.w500),
                                                        ),
                                                        InkWell(
                                                            onTap: () {
                                                              Navigator.of(context)
                                                                  .pop();
                                                            },
                                                            child: Icon(Icons
                                                                .clear_rounded)),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "piece";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              top: 10, left: 10),
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            color: Colors.blue[50],
                                                            border: Border.all(
                                                              color: Colors.blue,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            "piece",
                                                            style: TextStyle(
                                                                color: Colors.blue),
                                                          )),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "gm";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                            top: 10,
                                                          ),
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("gm")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "ml";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                            top: 10,
                                                          ),
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("ml")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "liter";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                            top: 10,
                                                          ),
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("liter")),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "mm";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                            left: 10,
                                                          ),
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("mm")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "kg";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("kg")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "ft";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("ft")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "meter";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("meter")),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "sq.ft";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                            left: 10,
                                                          ),
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("sq.ft")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "set";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("set")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "bunch";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("bunch")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "bundle";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child:
                                                                  Text("bundle")),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "packet";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                            left: 10,
                                                          ),
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child:
                                                                  Text("packet")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "box";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("box")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "pound";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("pound")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "dozen";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("dozen")),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "pair";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: 10, bottom: 10),
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("pair")),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedUnit = "inch";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                            bottom: 10,
                                                          ),
                                                          height: 40,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10.0),
                                                          ),
                                                          child: Center(
                                                              child: Text("inch")),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Icon(Icons.keyboard_arrow_down))
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: txt_productdetails,
                    decoration: InputDecoration(
                        label: Text("Product Details"),
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
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [Text("KEY"), Text("VALUE")],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: txt_key,
                          decoration: InputDecoration(
                              label: Text("Specification Name"),
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
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: txt_value,
                          decoration: InputDecoration(
                              label: Text("Specification Value"),
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
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        add();
                      },
                      child: Text(
                        'Add Specification',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: specifications.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(specifications[index]["key"]
                                      .toString()
                                      .toUpperCase()),
                                ),
                                Text(specifications[index]["value"].toString())
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.grey[30],
                            ),
                          ],
                        );
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          addProduct();
                        },
                        child: Text(
                          'Save',
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
          ],
        ),
      ),
    );
  }
}

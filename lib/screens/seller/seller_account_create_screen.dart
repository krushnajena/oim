import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/provider/location_provider.dart';
import 'package:oim/screens/common/privacy_policy_screen.dart';
import 'package:oim/screens/common/terms_condistion_screen.dart';
import 'package:oim/screens/flash_screen.dart';
import 'package:oim/screens/seller/add_business_hour.dart';
import 'package:oim/screens/seller/add_business_location.dart';
import 'package:oim/screens/seller/create_business_hour_screen.dart';
import 'package:oim/screens/seller/seller_bottom_appbar.dart';
import 'package:oim/screens/seller/seller_registration_success_screen.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SellerAccountCreateScreen extends StatefulWidget {
  const SellerAccountCreateScreen({Key? key}) : super(key: key);

  @override
  State<SellerAccountCreateScreen> createState() =>
      _SellerAccountCreateScreenState();
}

class _SellerAccountCreateScreenState extends State<SellerAccountCreateScreen> {
  TextEditingController? _controller;
  TextEditingController txt_name = new TextEditingController();
  TextEditingController txt_businessname = new TextEditingController();

  TextEditingController txt_contactinfo = new TextEditingController();
  bool contactnoValidationFailed = false;
  String? streetaddress;
  String? city;
  String? statename;
  String? areaname;
  String? pincode;
  double? lat;
  double? lang;
  String? landmark;
  String? address;
  //String _initialValue;
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';
  File? _pickedImage;
  var bisinesshour;
  final List<Map<String, dynamic>> _items = [];

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void getCategories() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var encoded = Uri.parse(get_categoris);
    http.get(encoded).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson);
        for (int i = 0; i < mjson["data"]["categories"].length; i++) {
          setState(() {
            _items.add(
              {
                'value': mjson["data"]["categories"][i]["_id"],
                'label': mjson["data"]["categories"][i]["categoryname"],
              },
            );
          });
        }
        setState(() {
          _items.add(
            {
              'value': 'Restaurant',
              'label': 'Restaurant',
            },
          );
        });
      }
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void registerSi() async {
    setState(() {
      contactnoValidationFailed = false;
    });
    if (txt_contactinfo.text != "") {
      if (txt_businessname.text != "") {
        if (txt_name.text != "") {
          if (txt_contactinfo.text.length == 10) {
            if (address != null) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
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

              String? userid = preferences.getString("userid");
              final mimeTypeData = lookupMimeType(_pickedImage!.path.toString(),
                      headerBytes: [0xFF, 0xD8])!
                  .split('/');
              final imageUploadRequest = http.MultipartRequest(
                  'POST', Uri.parse(post_seller_register));
              final file = await http.MultipartFile.fromPath(
                  'logo', _pickedImage!.path,
                  contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
              imageUploadRequest.files.add(file);
              imageUploadRequest.fields['userid'] = userid.toString();
              imageUploadRequest.fields['businessname'] = txt_businessname.text;
              imageUploadRequest.fields['businesscatagories'] = _valueChanged;
              imageUploadRequest.fields['ownername'] = txt_name.text;
              imageUploadRequest.fields['businesscontactinfo'] =
                  txt_contactinfo.text;
              imageUploadRequest.fields['streetaddress'] =
                  streetaddress.toString();
              imageUploadRequest.fields['city'] = city.toString();
              imageUploadRequest.fields['pincode'] = pincode.toString();
              imageUploadRequest.fields['latitude'] = lat.toString();
              imageUploadRequest.fields['longitude'] = lang.toString();
              imageUploadRequest.fields['landmark'] = landmark.toString();
              imageUploadRequest.fields['address'] = address.toString();
              if (bisinesshour != null) {
                //imageUploadRequest.fields['sunday'] = bisinesshour["sunday"].toString();
                imageUploadRequest.fields['sundayopeningtime'] =
                    bisinesshour["sundayopeningtime"];
                imageUploadRequest.fields['sundayclosingtime'] =
                    bisinesshour["sundayclosingtime"];

                //imageUploadRequest.fields['monday'] = bisinesshour["monday"].toString();
                imageUploadRequest.fields['mondayopeningtime'] =
                    bisinesshour["mondayopeningtime"];
                imageUploadRequest.fields['mondayclosinmonday'] =
                    bisinesshour["mondayclosingtime"];

                //imageUploadRequest.fields['tuesday'] = bisinesshour["tuesday"].toString();
                imageUploadRequest.fields['tuesdayopeningtime'] =
                    bisinesshour["tuesdayopeningtime"];
                imageUploadRequest.fields['tuesdayclosintuesday'] =
                    bisinesshour["tuesdayclosingtime"];

                //imageUploadRequest.fields['wednesday'] = bisinesshour["wednessday"].toString();
                imageUploadRequest.fields['wednesdayopeningtime'] =
                    bisinesshour["wednessdayopeningtime"];
                imageUploadRequest.fields['wednesdayclosingtiwednes'] =
                    bisinesshour["wednessdayclosingtime"];

                //imageUploadRequest.fields['thursday'] = bisinesshour["thursday"];
                imageUploadRequest.fields['thursdayopeningtime'] =
                    bisinesshour["thursdayopeningtime"];
                imageUploadRequest.fields['thursdayclosingtime'] =
                    bisinesshour["thursdayclosingtime"];

                //imageUploadRequest.fields['friday'] = bisinesshour["friday"];
                imageUploadRequest.fields['fridayopeningtime'] =
                    bisinesshour["fridayopeningtime"];
                imageUploadRequest.fields['fridayclosingtime'] =
                    bisinesshour["fridayclosingtime"];

                //imageUploadRequest.fields['saturday'] = bisinesshour["saturday"];
                imageUploadRequest.fields['saturdayopeningtime'] =
                    bisinesshour["saturdayopeningtime"];
                imageUploadRequest.fields['saturdayclosingtime'] =
                    bisinesshour["saturdayclosingtime"];
              }
              try {
                final streamedResponse = await imageUploadRequest.send();
                final response =
                    await http.Response.fromStream(streamedResponse);
                print(response.statusCode);

                if (response.statusCode == 200) {
                  preferences.setString("businessname", txt_businessname.text);
                  preferences.setString("businesscategory", _valueChanged);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SellerRegistrationSuccessScreen()),
                      (Route<dynamic> route) => false);
                }
              } catch (e) {
                print(e);
                Navigator.of(context).pop();
              }
            } else {
              showInSnackBar("Please Add Business Address.");
            }
          } else {
            setState(() {
              contactnoValidationFailed = true;
            });
            showInSnackBar("Contact No Should Be 10 Digits");
          }
        } else {
          showInSnackBar("Please Enter Owner Name");
        }
      } else {
        showInSnackBar("Please Enter Business Name");
      }
    } else {
      setState(() {
        contactnoValidationFailed = true;
      });
      showInSnackBar("Please Enter Contact No.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  void _pickImage(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage = File(pickedImageFile!.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedImage = File(pickedImageFile!.path.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: new Text("Confirmation"),
                        content: new Text(
                            "Do you want to Exit Registartion Process?"),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text("Yes",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.clear();

                              Navigator.of(context).pop();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          FlashScreen()),
                                  (Route<dynamic> route) => false);
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text("Exit",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ));
            }),
        backgroundColor: Colors.white,
        title: Text(
          "Make your business profile",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                height: 110,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
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
                                      _pickImage("gallery");
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.videocam),
                                    title: new Text('Camera'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _pickImage("camera");
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 13),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: _pickedImage == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    size: 35,
                                    color: Colors.blue,
                                  )
                                : Image.file(
                                    File(_pickedImage!.path.toString()),
                                  )),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add Photo",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Add business logo / store /\nvisiting card photo",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text("Business Name",
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SizedBox(
                  // width: 350,
                  child: TextField(
                controller: txt_businessname,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'eg. Rasm Sarees',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                autofocus: false,
                obscureText: false,
              )),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Business Categories",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SizedBox(
                // width: 350,
                child: _items.length > 0
                    ? SelectFormField(
                        type: SelectFormFieldType.dropdown,
                        controller: _controller,
                        //initialValue: _initialValue,

                        labelText: 'Business Category',
                        changeIcon: false,
                        dialogTitle: 'Please select your business category',
                        dialogCancelBtn: 'CANCEL',
                        enableSearch: true,
                        dialogSearchHint: 'Search item',
                        items: _items,
                        onChanged: (val) => setState(() => _valueChanged = val),
                        validator: (val) {
                          setState(() => _valueToValidate = val ?? '');
                          return null;
                        },
                        onSaved: (val) =>
                            setState(() => _valueSaved = val ?? ''),
                      )
                    : SizedBox(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Owner Name",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SizedBox(
                  // width: 350,
                  child: TextField(
                controller: txt_name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'eg. Suraj Das',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                autofocus: false,
                obscureText: false,
              )),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                "Business Contact Info",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SizedBox(
                  // width: 350,
                  child: TextField(
                keyboardType: TextInputType.phone,
                controller: txt_contactinfo,
                maxLength: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: contactnoValidationFailed == false
                          ? Colors.grey
                          : Colors.red,
                    ),
                  ),
                  hintText: 'Contact Phone Number',
                  hintStyle: TextStyle(
                      color: contactnoValidationFailed == false
                          ? Colors.grey
                          : Colors.red),
                ),
                autofocus: false,
                obscureText: false,
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Divider(
                color: Colors.black12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateBusinessHourScreen()),
                  );
                  setState(() {
                    bisinesshour = result;
                  });
                },
                child: Container(
                  // padding: EdgeInsets.only(right: 30),
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: Colors.blue,
                      ),
                      Text(
                        "Add business hours",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
              child: InkWell(
                onTap: () {
                  locationData.getCurrentPosition().then((value) async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const AddBusinessLocationScreen()),
                    );
                    setState(() {
                      streetaddress = result["street_address"];
                      city = result["city"];
                      areaname = result["areaname"];
                      statename = result["statename"];
                      pincode = result["pincoide"];
                      landmark = result["landmark"];
                      lat = result["lat"];
                      lang = result["lang"];
                      address = result["address"];
                    });
                  }).catchError((onError) {
                    print(onError.toString());
                  });
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                      Text(
                        " Add business location",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            address != null
                ? Container(
                    margin: EdgeInsets.only(top: 30, left: 20, right: 30),
                    height: 110,
                    // width: 350,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(left: 15, top: 13),
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                                child: Icon(
                              Icons.location_city,
                              size: 35,
                              color: Colors.blue,
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Added Address",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: Text(
                                  streetaddress! +
                                      ", " +
                                      areaname! +
                                      ", " +
                                      city! +
                                      ", " +
                                      statename! +
                                      ", " +
                                      pincode!,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ))
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 31, right: 30),
              child: Row(
                children: [
                  Text(
                    "By continuing, you're agreeing to these",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TermsAndCoditionScreen()));
                      },
                      child: Text(
                        "Terms and ",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      )),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TermsAndCoditionScreen()));
                      },
                      child: Text(
                        "Conditions ",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      )),
                  Text(
                    "and",
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyPolicyScreen()));
                      },
                      child: Text(
                        " Privacy Policy",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  registerSi();
                  //  Navigator.push(context,
                  //    MaterialPageRoute(builder: (context) => SellingNow()));
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      )),
    );
  }
}

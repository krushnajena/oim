import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:oim/constants/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyQrScreen extends StatefulWidget {
  const MyQrScreen({Key? key}) : super(key: key);

  @override
  State<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends State<MyQrScreen> {
  String userid = "";
  String storename = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    // P
  }

  void getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("userid")!;
      storename = preferences.getString("businessname")!;
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  ScreenshotController screenshotController = ScreenshotController();
  late File customFile;
  Future<void> downloadQr(
    Uint8List capturedImage,
  ) async {
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

    Directory tempDir = await getApplicationDocumentsDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';
    print(path);
    print("7377483873827382987392");
    customFile = await File(path).writeAsBytes(capturedImage);
    final result = await ImageGallerySaver.saveFile(path);
    showInSnackBar("QR Saved To Your Galler.");
    //final imagePath = await File('${tempDir.path}/image.png').create();
    //await imagePath.writeAsBytes(capturedImage);

    /// Share Plugin
    // await Share.shareFiles([imagePath.path]);
    Navigator.of(context).pop();
  }

  Widget CustomWidget() {
    return Container(
      width: 400,
      height: 550,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Container(
                        height: 220,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(255, 17, 93, 156),
                            ),
                            color: Color.fromARGB(255, 17, 93, 156),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Image(
                                image: AssetImage("images/oimlogo.png"),
                                height: 130,
                                width: 130,
                              ),
                              Text(
                                "Scan QR to check our products",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 150,
                        ),
                        height: 205,
                        width: 170,
                        child: userid != ""
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Card(
                                    child: QrImage(
                                      padding: EdgeInsets.all(15),
                                      data: userid,
                                      version: QrVersions.auto,
                                      //  size: 170.0,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 17, 93, 156),
                    ),
                    color: Color.fromARGB(255, 17, 93, 156),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  storename,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "To Know Our Upcoming Offers ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Follow Our Store On OffersinMarket App",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 30,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Download The App Now"),
                  SizedBox(
                    width: 10,
                  ),
                  Image(
                    image: AssetImage("images/playstore.png"),
                    fit: BoxFit.fill,
                  )
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title: Text("My Store QR"),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: OutlineButton(
                  onPressed: () {},
                  child: Text("Share QR"),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: RaisedButton(
                  color: Colors.black,
                  onPressed: () async {
                    await screenshotController
                        .captureFromWidget(CustomWidget())
                        .then((capturedImage) async {
                      await downloadQr(capturedImage);
                    });
                  },
                  child: Text(
                    "Download QR",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      //bottomNavigationBar: Container(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            CustomWidget(),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return new Container(
                            height: 300.0,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "How To Use?",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "images/print1.png",
                                          height: 50,
                                          width: 50,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            "Get print out & paste the QR in your store")
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 70,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "images/scan1.png",
                                          height: 50,
                                          width: 50,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          "Ask customers to Scan QR to open ypur digital showroom",
                                          overflow: TextOverflow.visible,
                                        ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "images/buy1.png",
                                        height: 50,
                                        width: 50,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "Customes can view your online store.")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ));
                      });
                },
                child: Text("How To Use This?"))
          ],
        ),
      )),
    );
  }
}

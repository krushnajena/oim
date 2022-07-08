import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oim/screens/seller/seller_account_create_screen.dart';
import 'package:oim/screens/seller/sellerlocationsearch.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oim/constants/constant.dart';

import 'package:oim/constants/urls.dart';

import 'package:oim/models/location_model.dart';

import 'package:oim/provider/location_provider.dart';

import 'package:http/http.dart' as http;

class AddBusinessLocationScreen extends StatefulWidget {
  const AddBusinessLocationScreen({Key? key}) : super(key: key);

  @override
  State<AddBusinessLocationScreen> createState() =>
      _AddBusinessLocationScreenState();
}

class _AddBusinessLocationScreenState extends State<AddBusinessLocationScreen> {
  GoogleMapController? _controller;
  LatLng? currentLocation;
  TextEditingController txt_city = TextEditingController();
  TextEditingController txt_streetaddress = TextEditingController();
  TextEditingController txt_pincode = TextEditingController();
  TextEditingController txt_landmark = TextEditingController();
  TextEditingController txt_address = TextEditingController();

  String cityname = "";
  String areaname = "";
  String statename = "";
  int? val = -1;
  bool showAllParameters = true;
  //String statename = '';
  String stateid = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  loadingDialog(LocationModel locationModel) async {
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
                  children: <Widget>[
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

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("Address", locationModel.address.toString());
    preferences.setString("cityname", locationModel.cityname.toString());
    preferences.setString("areaname", locationModel.areaname.toString());
    preferences.setString("postalcode", locationModel.postalcode.toString());
    preferences.setString("latitude", locationModel.lat.toString());
    preferences.setString("logitude", locationModel.lng.toString());

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => SellerAccountCreateScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    setState(() {
      currentLocation = LatLng(
          locationData.latitude as double, locationData.logitude as double);
    });
    void onCreated(GoogleMapController controller) {
      setState(() {
        _controller = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: currentLocation as LatLng, zoom: 22),
                      zoomControlsEnabled: false,
                      minMaxZoomPreference: MinMaxZoomPreference(1.5, 18.8),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      mapToolbarEnabled: true,
                      onCameraMove: (CameraPosition position) {
                        locationData.onCameraMove(position);
                      },
                      onMapCreated: onCreated,
                      onCameraIdle: () {
                        locationData.getMoveCamera();
                      }),
                  Center(
                    child: Image.asset(
                      "images/pin.png",
                      height: 64,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: val == 3
                  ? showAllParameters == true
                      ? 550
                      : 245
                  : showAllParameters == true
                      ? 400
                      : 185,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: locationData.selectedAddress != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          showAllParameters == true
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: TextField(
                                    controller: txt_streetaddress,
                                    decoration: const InputDecoration(
                                      labelText: 'Address',
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          showAllParameters == true
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: TextField(
                                    controller: txt_landmark,
                                    decoration: InputDecoration(
                                      labelText: 'Landmark',
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          showAllParameters == true
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 9.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    statename == ""
                                                        ? "Select State"
                                                        : statename +
                                                            "," +
                                                            cityname +
                                                            ", " +
                                                            areaname,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16),
                                                  ),
                                                  InkWell(
                                                      onTap: () async {
                                                        final result =
                                                            await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const SellerLocationSeacrhScreen()));
                                                        setState(() {
                                                          statename = result[
                                                              "statename"];
                                                          cityname =
                                                              result["city"];
                                                          areaname = result[
                                                              "areaname"];
                                                        });
                                                      },
                                                      child: Icon(Icons
                                                          .keyboard_arrow_down))
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
                                )
                              : const SizedBox(),
                          showAllParameters == true
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: TextField(
                                    controller: txt_pincode,
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    decoration: const InputDecoration(
                                      labelText: 'Pin Code',
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 18,
                          ),
                          InkWell(
                            onTap: showAllParameters == false
                                ? () async {
                                    setState(() {
                                      showAllParameters = true;
                                    });
                                  }
                                : () async {
                                    String address = locationData
                                            .selectedAddress!.street
                                            .toString() +
                                        ", " +
                                        locationData
                                            .selectedAddress!.subLocality
                                            .toString() +
                                        ", " +
                                        locationData.selectedAddress!.locality
                                            .toString() +
                                        ", " +
                                        locationData
                                            .selectedAddress!.administrativeArea
                                            .toString() +
                                        "," +
                                        locationData.selectedAddress!.postalCode
                                            .toString();
                                    String addressType = "";
                                    var adr = {
                                      "street_address": txt_streetaddress.text,
                                      "city": cityname,
                                      "areaname": areaname,
                                      "statename": statename,
                                      "pincoide": txt_pincode.text,
                                      "landmark": txt_landmark.text,
                                      "lat": locationData.latitude,
                                      "lang": locationData.logitude,
                                      "address": address
                                    };
                                    Navigator.pop(context, adr);
                                  },
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: double.infinity,
                              height: 50.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.blue,
                              ),
                              child: Text(
                                'Save and Proceed',
                                style: white14BoldTextStyle,
                              ),
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
    );
  }
}

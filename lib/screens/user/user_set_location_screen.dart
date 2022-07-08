import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/provider/location_provider.dart';
import 'package:oim/screens/seller/seller_bottom_appbar.dart';
import 'package:oim/screens/user/user_bottom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSetLocationScreen extends StatefulWidget {
  const UserSetLocationScreen({Key? key}) : super(key: key);

  @override
  State<UserSetLocationScreen> createState() => _UserSetLocationScreenState();
}

class _UserSetLocationScreenState extends State<UserSetLocationScreen> {
  GoogleMapController? _controller;
  LatLng? currentLocation;

  int? val = -1;
  bool showAllParameters = true;
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
                      ? 110
                      : 110
                  : showAllParameters == true
                      ? 110
                      : 110,
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
                          Text(locationData.selectedAddress!.street.toString() +
                              ", " +
                              locationData.selectedAddress!.subLocality
                                  .toString() +
                              ", " +
                              locationData.selectedAddress!.locality
                                  .toString() +
                              ", " +
                              locationData.selectedAddress!.administrativeArea
                                  .toString() +
                              "," +
                              locationData.selectedAddress!.postalCode
                                  .toString()),
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
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    preferences.setString("address", address);
                                    preferences.setDouble(
                                        "lat", locationData.latitude!);
                                    preferences.setDouble(
                                        "lang", locationData.logitude!);

                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserBottomAppBar()),
                                        (Route<dynamic> route) => false);
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

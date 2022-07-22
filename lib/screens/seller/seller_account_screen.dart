import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/flash_screen.dart';
import 'package:oim/screens/seller/app_settings_screen.dart';
import 'package:oim/screens/seller/buy_a_plan_or_myorders_screen.dart';
import 'package:oim/screens/seller/cusine_create_screen.dart';
import 'package:oim/screens/seller/price_for_two_screen.dart';
import 'package:oim/screens/seller/purchase_history_screen.dart';
import 'package:oim/screens/seller/resturent_setting_screen.dart';
import 'package:oim/screens/seller/seller_account_create_screen.dart';
import 'package:oim/screens/seller/seller_bottom_appbar.dart';
import 'package:oim/screens/seller/seller_help_center.dart';
import 'package:oim/screens/seller/seller_profile_update_screen.dart';
import 'package:oim/screens/user/notification_screen.dart';
import 'package:oim/screens/user/user_hep_center_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerAccountScreen extends StatefulWidget {
  const SellerAccountScreen({Key? key}) : super(key: key);

  @override
  State<SellerAccountScreen> createState() => _SellerAccountScreenState();
}

class _SellerAccountScreenState extends State<SellerAccountScreen> {
  String businessName = "";
  String categoryName = "";

  void getBusinessDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      businessName = preferences.getString("businessname")!;
      categoryName = preferences.getString("businesscategory")!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBusinessDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => SellerBottomAppBar()),
                (Route<dynamic> route) => false),
          ),
          elevation: 0,
          title: Text(
            "ACCOUNT",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                },
                child: Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SellerProfileUpdateScreen()));
              },
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.black38,
                    child: IconButton(
                      icon: Icon(
                        Icons.person_rounded,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SellerProfileUpdateScreen()));
                      },
                    ),
                  ),
                ),
                title: Text(
                  businessName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Change business account information",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SellerProfileUpdateScreen()));
                  },
                ),
              ),
            ),

            Container(
              height: 8,
              width: double.infinity,
              color: Colors.grey[200],
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppSettingsScreen()));
              },
              child: ListTile(
                leading: Container(
                    margin: EdgeInsets.only(top: 10, left: 13),
                    child: Image.asset(
                      "images/8.jpeg",
                      height: 35,
                      width: 35,
                    )),
                title: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "App settings",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppSettingsScreen()));
                  },
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black38,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BuyAPlanOrMyOrderScreen()));
              },
              child: ListTile(
                leading: Container(
                    margin: EdgeInsets.only(top: 10, left: 13),
                    child: Image.asset(
                      "images/card2.png",
                      height: 35,
                      width: 35,
                    )),
                title: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Buy Plans & My Order",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
              ),
            ),

//   Divider(
//                 height: 1,
//                 color: Colors.black38,
//               ),

//              ListTile(

//                   leading: Container(

//                             margin: EdgeInsets.only(top: 10, left: 13),

//                             child: Image.asset(

//                               "images/11.jpeg",

//                               height: 35,

//                               width: 35,

//                             )),

//                             title: Padding(

//                               padding: EdgeInsets.only(top:8),

//                               child: Text(

//                              "Price for two",
//                             style: TextStyle(

//                               fontSize: 16,

//                             ),

//                           ),

//                             ),

//                             trailing: IconButton(

//                             icon: Icon(

//                               Icons.arrow_forward_ios_outlined,

//                               size: 15,

//                               color: Colors.grey,

//                             ),

//                             onPressed: () {},

//                           ),
// ),

            categoryName == "Restaurant"
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CusineCreateScreen()));
                    },
                    child: ListTile(
                      leading: Container(
                          margin: EdgeInsets.only(top: 10, left: 13),
                          child: Image.asset(
                            "images/10.jpeg",
                            height: 35,
                            width: 35,
                          )),
                      title: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "Cusines",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: Colors.grey,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  )
                : SizedBox(),
            categoryName == "Restaurant"
                ? Divider(
                    height: 1,
                    color: Colors.black38,
                  )
                : SizedBox(),

            categoryName == "Restaurant"
                ? Divider(
                    height: 1,
                    color: Colors.black38,
                  )
                : SizedBox(),

            categoryName == "Restaurant"
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PriceForTwoScreen()));
                    },
                    child: ListTile(
                      leading: Container(
                          margin: EdgeInsets.only(top: 10, left: 13),
                          child: Image.asset(
                            "images/11.jpeg",
                            height: 35,
                            width: 35,
                          )),
                      title: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "Price For Two",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: Colors.grey,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  )
                : const SizedBox(),
            categoryName == "Restaurant"
                ? const Divider(
                    height: 1,
                    color: Colors.black38,
                  )
                : const SizedBox(),

            Divider(
              height: 1,
              color: Colors.black38,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserHelpCenterScreen()));
              },
              child: ListTile(
                leading: Container(
                    margin: EdgeInsets.only(top: 10, left: 13),
                    child: Image.asset(
                      "images/3.jpeg",
                      height: 35,
                      width: 35,
                    )),
                title: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Help center",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
              ),
            ),

            Divider(
              height: 1,
              color: Colors.black38,
            ),
            ListTile(
                leading: Container(
                    margin: EdgeInsets.only(top: 10, left: 13),
                    child: Image.asset(
                      "images/4.jpeg",
                      height: 35,
                      width: 35,
                    )),
                title: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Rate us",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                )),
            Divider(
              height: 1,
              color: Colors.black38,
            ),

            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                          title: new Text("Confirmation"),
                          content: new Text("Do you want to logout?"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              child: Text("Yes"),
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
                              child: Text("Exit"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ));
              },
              child: ListTile(
                  leading: Container(
                      margin: EdgeInsets.only(top: 10, left: 13),
                      child: Image.asset(
                        "images/2.jpeg",
                        height: 35,
                        width: 35,
                      )),
                  title: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                  )),
            ),

            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Center(
                child: Text("Oim- v 1.0122"),
              ),
            ),
          ],
        ));
  }
}

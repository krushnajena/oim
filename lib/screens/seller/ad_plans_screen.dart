import 'package:flutter/material.dart';
import 'package:oim/screens/seller/BoostYourStoreToTopScreen.dart';
import 'package:oim/screens/seller/banner_ad_screen.dart';
import 'package:oim/screens/seller/brand_outlet_screen.dart';
import 'package:oim/screens/seller/featured_ad_package.dart';
import 'package:oim/screens/seller/select_ad_to_make_featured_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdPlanScreen extends StatefulWidget {
  const AdPlanScreen({Key? key}) : super(key: key);

  @override
  State<AdPlanScreen> createState() => _AdPlanScreenState();
}

class _AdPlanScreenState extends State<AdPlanScreen> {
  String businessName = "";
  String categoryName = "";

  void getBusinessDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      businessName = preferences.getString("businessname")!;
      categoryName = preferences.getString("businesscategory")!;
    });
    print(categoryName);
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
        title: Text("Advertisement Plans"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              categoryName != "Restaurant"
                  ? SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeaturedAdPackages()));
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: Image.asset("images/advimg5.jpg"),
                                ),
                                Expanded(
                                  child: Text(
                                    "Offer Zone Advertisement",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(20)),
                                  height: 25,
                                  width: 25,
                                  child:
                                      Icon(Icons.keyboard_arrow_right_rounded),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  : SizedBox(),
              SizedBox(height: 10),
              SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BoostYourStoreToTop()));
                      //Navigator.push(context,
                      //  MaterialPageRoute(builder: (context) => BuyPlans1()));
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: Image.asset("images/advimg6.jpg"),
                            ),
                            Expanded(
                              child: Text(
                                "Boost Your Store To Top",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 25,
                              width: 25,
                              child: Icon(Icons.keyboard_arrow_right_rounded),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 10),
              SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BannerAdScreen()));
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: Image.asset("images/advimg8.jpg"),
                            ),
                            Expanded(
                              child: const Text(
                                "Banner Advertisement",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 25,
                              width: 25,
                              child: const Icon(
                                  Icons.keyboard_arrow_right_rounded),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 10),
              SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BrandOutletScreen()));
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: Image.asset("images/advimg7.jpg"),
                            ),
                            Expanded(
                              child: const Text(
                                "Brand Outlet",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 25,
                              width: 25,
                              child: const Icon(
                                  Icons.keyboard_arrow_right_rounded),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}

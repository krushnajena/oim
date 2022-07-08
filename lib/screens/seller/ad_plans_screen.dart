import 'package:flutter/material.dart';
import 'package:oim/screens/seller/banner_ad_screen.dart';
import 'package:oim/screens/seller/brand_outlet_screen.dart';
import 'package:oim/screens/seller/featured_ad_package.dart';
import 'package:oim/screens/seller/select_ad_to_make_featured_screen.dart';

class AdPlanScreen extends StatefulWidget {
  const AdPlanScreen({Key? key}) : super(key: key);

  @override
  State<AdPlanScreen> createState() => _AdPlanScreenState();
}

class _AdPlanScreenState extends State<AdPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Plans"),
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
              SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SelectAdToMakeFeaturedScreen()));
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.asset("images/advimg5.jpg"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Offer Zone Advertisement",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 20,
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
                              builder: (context) => FeaturedAdPackages()));
                      //Navigator.push(context,
                      //  MaterialPageRoute(builder: (context) => BuyPlans1()));
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.asset("images/advimg6.jpg"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Boost Your Store To Top",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 30,
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
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.asset("images/advimg8.jpg"),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "Banner Advertisement",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 42,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(20)),
                            height: 25,
                            width: 25,
                            child:
                                const Icon(Icons.keyboard_arrow_right_rounded),
                          )
                        ],
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
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.asset("images/advimg7.jpg"),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "Brand Outlet",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 110,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(20)),
                            height: 25,
                            width: 25,
                            child:
                                const Icon(Icons.keyboard_arrow_right_rounded),
                          )
                        ],
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

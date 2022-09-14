import 'package:flutter/material.dart';
import 'package:oim/screens/seller/promote_your_business_screen.dart';
import 'package:oim/screens/seller/purchase_history_screen.dart';

class BuyAPlanOrMyOrderScreen extends StatefulWidget {
  const BuyAPlanOrMyOrderScreen({Key? key}) : super(key: key);

  @override
  State<BuyAPlanOrMyOrderScreen> createState() =>
      _BuyAPlanOrMyOrderScreenState();
}

class _BuyAPlanOrMyOrderScreenState extends State<BuyAPlanOrMyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Buy Plans & My Orders"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 2),
            height: 720,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PromoteYourBusinessScreen()));
                  },
                  child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 9, left: 9),
                          child: Image.asset(
                            "images/card2.png",
                            height: 35,
                            width: 35,
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 9, left: 9),
                        child: Text(
                          "Buy Plans",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PurchaseHistoryScreen()));
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 9, left: 9),
                        child: Image.asset(
                          "images/9.jpeg",
                          height: 35,
                          width: 35,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 9, left: 9),
                        child: Text(
                          "My Orders",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PurchaseHistoryScreen()));
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 9, left: 9),
                        child: Image.asset(
                          "images/9.jpeg",
                          height: 35,
                          width: 35,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 9, left: 9),
                        child: Text(
                          "Invoice Section",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

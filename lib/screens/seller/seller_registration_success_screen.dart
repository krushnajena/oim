import 'package:flutter/material.dart';
import 'package:oim/screens/seller/seller_bottom_appbar.dart';

class SellerRegistrationSuccessScreen extends StatefulWidget {
  const SellerRegistrationSuccessScreen({Key? key}) : super(key: key);

  @override
  State<SellerRegistrationSuccessScreen> createState() =>
      _SellerRegistrationSuccessScreenState();
}

class _SellerRegistrationSuccessScreenState
    extends State<SellerRegistrationSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Icon(Icons.arrow_back),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 20, top: 50),
              child: Text(
                "Get your business online in less than a minute for free",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20),
                    height: 45,
                    width: 45,
                    child: Image.asset("images/oimp4.png")),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Increase your sales",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Online store offer you to showcase all\nproducts to customers resulting more sales.",
                        style: TextStyle(color: Colors.black38))
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20),
                    height: 45,
                    width: 45,
                    child: Image.asset("images/oimp6.png")),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Be a leader among retailer",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "World is moving online faster and we help\nyou to be the leader in your community.",
                        style: TextStyle(color: Colors.black38))
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20),
                    height: 45,
                    width: 45,
                    child: Image.asset("images/oimp5.png")),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Compete with online players",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "We provide the platform to compete kwith big\nonline players in your locality.",
                        style: TextStyle(color: Colors.black38))
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 220,
            ),
            Center(
              child: SizedBox(
                height: 40,
                width: 350,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SellerBottomAppBar()));
                  },
                  child: Text(
                    "Start Selling Now",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

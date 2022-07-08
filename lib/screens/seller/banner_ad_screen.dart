import 'package:flutter/material.dart';

class BannerAdScreen extends StatefulWidget {
  const BannerAdScreen({Key? key}) : super(key: key);

  @override
  State<BannerAdScreen> createState() => _BannerAdScreenState();
}

class _BannerAdScreenState extends State<BannerAdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banner Ad Screen"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Center(
              child: SizedBox(
                height: 120,
                width: 120,
                child: Image.asset("images/advimg8.jpg"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
              ),
              child: Text(
                "Get noticed instantly by Customers to maximize your Product/Store/Offer Visibility and Sales by Promoting through banner Ad which will be displayed in the Slider Section.",
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w700, height: 1.5),
              ),
            ),
            Divider(
              color: Colors.black12,
              height: 30,
              thickness: 5,
            ),
            SizedBox(
              width: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("See Example",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline)),
              ],
            ),
            Center(
              child: SizedBox(
                height: 120,
                width: 120,
                child: Image.asset("images/advimg10.png"),
              ),
            ),
            Center(
                child: Text(
                    'To know more, Please fill out the form below\nand we will get back to you as soon as possible.',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        height: 1.5))),
            Center(
              child: SizedBox(
                  height: 450,
                  width: 350,
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 300,
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 15),
                              border: OutlineInputBorder(),
                              labelText: '* Name',
                              hintText: 'Name',
                            ),
                            autofocus: false,
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 300,
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 15),
                              border: OutlineInputBorder(),
                              labelText: '* Email',
                              hintText: 'Email',
                            ),
                            autofocus: false,
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 300,
                          child: const TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 15),
                              border: OutlineInputBorder(),
                              labelText: '* Phone',
                              hintText: 'Phone',
                            ),
                            autofocus: false,
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 300,
                          child: const TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 15),
                              border: OutlineInputBorder(),
                              labelText: '* Message',
                              hintText: 'Message',
                            ),
                            autofocus: false,
                          )),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 50,
                        width: 300,
                        child: RaisedButton(
                          onPressed: () {},
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 95),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      )),
    );
  }
}

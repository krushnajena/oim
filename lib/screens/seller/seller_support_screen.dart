import 'package:flutter/material.dart';

class SellerSupportScreen extends StatefulWidget {
  const SellerSupportScreen({Key? key}) : super(key: key);

  @override
  State<SellerSupportScreen> createState() => _SellerSupportScreenState();
}

class _SellerSupportScreenState extends State<SellerSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.only(left: 41, top: 40,right: 40),
                child: Text(
                  "Please fill out the form below and we\nwill get back to you as soon as possible.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.only(top: 110, left: 40, right: 40),
                child: SizedBox(
                    height: 450,
                    width: 350,
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              width: 300,
                              child: TextField(
                                decoration: InputDecoration(
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
                                  border: OutlineInputBorder(),
                                  labelText: '* Email',
                                  hintText: 'Email',
                                ),
                                autofocus: false,
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              width: 300,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '* Phone',
                                  hintText: 'Phone',
                                ),
                                autofocus: false,
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              width: 300,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '* Message',
                                  hintText: 'Message',
                                ),
                                autofocus: false,
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            height: 50,
                            width: 300,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              onPressed: () {},
                              color: Colors.blue,
                              child: Padding(
                                padding: EdgeInsets.only(left: 95),
                                child: Row(
                                  // ignore: prefer_const_literals_to_create_immutables
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
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

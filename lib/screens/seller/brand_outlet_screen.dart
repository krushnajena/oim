import 'package:flutter/material.dart';

class BrandOutletScreen extends StatefulWidget {
  const BrandOutletScreen({Key? key}) : super(key: key);

  @override
  State<BrandOutletScreen> createState() => _BrandOutletScreenState();
}

class _BrandOutletScreenState extends State<BrandOutletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Brand Outlet"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                  child: Image.asset("images/advimg7.jpg"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Text(
                  "Make your brand stand out on Offersinmarket App and let the customer have direct access to your store directly from 'HomePage' by listing your store in 'Brand Outlet' section.",
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700, height: 1.5),
                  textAlign: TextAlign.justify,
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
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text("See Example",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline)),
                  ),
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
                  child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Text(
                  'To know more, Please fill out the form below and we will get back to you as soon as possible.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 0, 0, 0.541),
                  ),
                  textAlign: TextAlign.justify,
                ),
              )),
              Center(
                child: SizedBox(
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
                              maxLines: 8,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
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
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';

class QrStandPriceScreen extends StatefulWidget {
  const QrStandPriceScreen({Key? key}) : super(key: key);

  @override
  State<QrStandPriceScreen> createState() => _QrStandPriceScreenState();
}

class _QrStandPriceScreenState extends State<QrStandPriceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Stand Price"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(image: AssetImage("images/qrstand.jpeg")),
            SizedBox(height: 10),
            Text(
              "QR STAND",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "₹ 25.00",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      )),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CusineCreateScreen extends StatefulWidget {
  const CusineCreateScreen({Key? key}) : super(key: key);

  @override
  State<CusineCreateScreen> createState() => _CusineCreateScreenState();
}

class _CusineCreateScreenState extends State<CusineCreateScreen> {
  TextEditingController txt_cuisines = new TextEditingController();
  List cusines = [];
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var encoded = Uri.parse(postcus);
    http.post(encoded,
        body: jsonEncode({
          "cuisinename": txt_cuisines.text,
          "userid": preferences.getString("userid")
        }),
        headers: {"content-type": "application/json"}).then((value) {
      if (value.statusCode == 200) {
        showInSnackBar("Cuisine Created Successfully");
        getCusines();
      }
    });
  }

  void getCusines() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var encoded = Uri.parse(
        getcusinesbyuserid + preferences.getString("userid").toString());
    http.get(encoded).then((value) {
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        setState(() {
          cusines = mjson["data"]["cuisine"];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCusines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cusines"),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                controller: txt_cuisines,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: "Cusine Name",
                ),
                autofocus: false,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // ignore: deprecated_member_use
            SizedBox(
              height: 40,
              child: RaisedButton(
                onPressed: () {
                  // setPrice();
                  save();
                },
                color: Colors.blue,
                child: Center(
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cusines.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cusines[index]["cuisinename"].toString()),
                      Divider(
                        thickness: 1,
                      )
                    ],
                  );
                })
          ],
        ),
      )),
    );
  }
}

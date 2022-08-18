import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oim/constants/constant.dart';
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
          "cuisinename": selectedHobby,
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
        for (int i = 0;
            i < mjson["data"]["cuisine"][0]["cuisinename"].length;
            i++) {
          setState(() {
            selectedHobby!
                .add(mjson["data"]["cuisine"][0]["cuisinename"][i].toString());
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCusines();
  }

  List<String> hobbyList = [
    'Indian',
    'Chinese',
    'Tandoor',
    'South Indian',
    'North Indian',
    'Italian',
    'Thai',
    'Desserts',
    'Sea Foods'
  ];

  List<String>? selectedHobby = [];

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  children: hobbyList.map(
                    (hobby) {
                      bool isSelected = false;
                      if (selectedHobby!.contains(hobby)) {
                        isSelected = true;
                      }
                      return GestureDetector(
                        onTap: () {
                          if (!selectedHobby!.contains(hobby)) {
                            if (selectedHobby!.length < 5) {
                              selectedHobby!.add(hobby);
                              setState(() {});
                              print(selectedHobby);
                            }
                          } else {
                            selectedHobby!
                                .removeWhere((element) => element == hobby);
                            setState(() {});
                            print(selectedHobby);
                          }
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 4),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey,
                                      width: 2)),
                              child: Text(
                                hobby,
                                style: TextStyle(
                                    color:
                                        isSelected ? Colors.blue : Colors.grey,
                                    fontSize: 14),
                              ),
                            )),
                      );
                    },
                  ).toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 70,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                              onPressed: () {
                                save();
                              },
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

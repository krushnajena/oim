import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateBusinessCategoryScreen extends StatefulWidget {
  const UpdateBusinessCategoryScreen({Key? key}) : super(key: key);

  @override
  State<UpdateBusinessCategoryScreen> createState() =>
      _UpdateBusinessCategoryScreenState();
}

class _UpdateBusinessCategoryScreenState
    extends State<UpdateBusinessCategoryScreen> {
  void getCategories() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var encoded = Uri.parse(get_categoris);
    http.get(encoded).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson);
        for (int i = 0; i < mjson["data"]["categories"].length; i++) {
          setState(() {
            _items.add(
              {
                'value': mjson["data"]["categories"][i]["_id"],
                'label': mjson["data"]["categories"][i]["categoryname"],
              },
            );
          });
        }
        setState(() {
          _items.add(
            {
              'value': 'Restaurant',
              'label': 'Restaurant',
            },
          );
        });
      }
    });
  }

  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';
  TextEditingController? _controller;
  var bisinesshour;
  final List<Map<String, dynamic>> _items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Business Category"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              // width: 350,
              child: _items.length > 0
                  ? SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      controller: _controller,
                      //initialValue: _initialValue,

                      labelText: 'Business Category',
                      changeIcon: false,
                      dialogTitle: 'Please select your business category',
                      dialogCancelBtn: 'CANCEL',
                      enableSearch: true,
                      dialogSearchHint: 'Search item',
                      items: _items,
                      onChanged: (val) => setState(() => _valueChanged = val),
                      validator: (val) {
                        setState(() => _valueToValidate = val ?? '');
                        return null;
                      },
                      onSaved: (val) => setState(() => _valueSaved = val ?? ''),
                    )
                  : SizedBox(),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              color: Colors.blue,
              onPressed: () {
                //  Navigator.push(context,
                //    MaterialPageRoute(builder: (context) => SellingNow()));
              },
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

class SelectImageForChatScreen extends StatefulWidget {
  final File? _pickedImage2;

  const SelectImageForChatScreen(this._pickedImage2);

  @override
  State<SelectImageForChatScreen> createState() =>
      _SelectImageForChatScreenState();
}

class _SelectImageForChatScreenState extends State<SelectImageForChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: Colors.black),
                  ),
                  onPressed: () {
                    var adr = {"send": "0"};
                    Navigator.pop(context, adr);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: RaisedButton(
                  color: Colors.black,
                  onPressed: () async {
                    var adr = {"send": "1"};
                    Navigator.pop(context, adr);
                  },
                  child: Text(
                    "Send Image",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
                  child: Center(
            child: Image.file(
              File(widget._pickedImage2!.path.toString()),
            ),
          ))),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

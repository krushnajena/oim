import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          hintColor: Colors.transparent,
        ),
        child: Container(
          height: 42,
          child: TextField(
            decoration: InputDecoration(
                hintText: "Search from area, street name...",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                prefixIcon: (Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                fillColor: Colors.transparent,
                filled: true),
          ),
        ));
  }
}

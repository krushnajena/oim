import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/screens/seller/products_list_screen.dart';
import 'package:oim/screens/seller/seller_account_screen.dart';
import 'package:oim/screens/seller/seller_chat_screen.dart';
import 'package:oim/screens/seller/seller_dashboard_screen.dart';
import 'package:oim/screens/seller/story_create_screen.dart';
import 'package:oim/screens/seller/story_list_screen.dart';
import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SellerBottomAppBar extends StatefulWidget {
  const SellerBottomAppBar({Key? key}) : super(key: key);

  @override
  State<SellerBottomAppBar> createState() => _SellerBottomAppBarState();
}

class _SellerBottomAppBarState extends State<SellerBottomAppBar> {
  final PageController _pageController = PageController();
  ListQueue<int> _navigationQueue = ListQueue();
  final List<Widget> _screens = [
    SellerDashBoardScreen(),
    SellerChatScreen(),
    ProductsListScreen(),
    StoryListScreen(),
    SellerAccountScreen()
  ];

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    setState(() {
      setState(() {
        _selectedIndex = selectedIndex;
      });
    });
    _navigationQueue.addLast(selectedIndex);
    _pageController.jumpToPage(selectedIndex);
  }

  int noofunreadnotifications = 0;
  void getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var nencoded = Uri.parse(
        getunseennotifications + preferences.getString("userid").toString());
    http.get(nencoded).then((resp) {
      if (resp.statusCode == 200) {
        Map mnjson;
        mnjson = json.decode(resp.body);
        print("8778678437898877549889989898899889989889");
        print(mnjson);
        setState(() {
          noofunreadnotifications = mnjson["data"]["notifications"].length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigationQueue.isEmpty) return true;

        setState(() {
          _selectedIndex = _navigationQueue.last;
          _navigationQueue.removeLast();
        });
        _pageController.jumpToPage(_navigationQueue.last);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          child: BottomNavigationBar(
            selectedItemColor: Colors.blue,
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Icon(Icons.home_outlined,
                          color:
                              _selectedIndex == 0 ? Colors.blue : Colors.grey),
                      Text(
                        "Home",
                        style: TextStyle(
                            color: _selectedIndex == 0
                                ? Colors.blue
                                : Colors.grey),
                      ),
                    ],
                  ),
                  label: '',
                  backgroundColor:
                      _selectedIndex == 0 ? Colors.blue : Colors.grey),
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Icon(Icons.chat_outlined,
                          color:
                              _selectedIndex == 1 ? Colors.blue : Colors.grey),
                      Text(
                        "Chat",
                        style: TextStyle(
                            color: _selectedIndex == 1
                                ? Colors.blue
                                : Colors.grey),
                      ),
                    ],
                  ),
                  label: '',
                  backgroundColor:
                      _selectedIndex == 1 ? Colors.blue : Colors.grey),
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Icon(Icons.category_outlined,
                          size: 26,
                          color:
                              _selectedIndex == 2 ? Colors.blue : Colors.grey),
                      Text(
                        "Product",
                        style: TextStyle(
                            color: _selectedIndex == 2
                                ? Colors.blue
                                : Colors.grey),
                      ),
                    ],
                  ),
                  label: '',
                  backgroundColor:
                      _selectedIndex == 2 ? Colors.blue : Colors.grey),
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Icon(Icons.book_outlined,
                          color:
                              _selectedIndex == 3 ? Colors.blue : Colors.grey),
                      Text(
                        "Story",
                        style: TextStyle(
                            color: _selectedIndex == 3
                                ? Colors.blue
                                : Colors.grey),
                      ),
                    ],
                  ),
                  label: '',
                  backgroundColor:
                      _selectedIndex == 3 ? Colors.blue : Colors.grey),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    new Stack(
                      children: <Widget>[
                        Icon(Icons.account_circle_outlined,
                            color: _selectedIndex == 4
                                ? Colors.blue
                                : Colors.grey),
                        new Positioned(
                          right: 0,
                          child: new Container(
                            padding: EdgeInsets.all(1),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: new Text(
                              '$noofunreadnotifications',
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      "Account",
                      style: TextStyle(
                          color:
                              _selectedIndex == 4 ? Colors.blue : Colors.grey),
                    )
                  ],
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

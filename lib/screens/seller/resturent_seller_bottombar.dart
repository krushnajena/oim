import 'package:flutter/material.dart';
import 'package:oim/screens/seller/products_list_screen.dart';
import 'package:oim/screens/seller/resturent_setting_screen.dart';
import 'package:oim/screens/seller/seller_account_screen.dart';
import 'package:oim/screens/seller/seller_chat_screen.dart';
import 'package:oim/screens/seller/seller_dashboard_screen.dart';
import 'package:oim/screens/seller/story_create_screen.dart';
import 'package:oim/screens/seller/story_list_screen.dart';

class RestSellerBottomAppBar extends StatefulWidget {
  const RestSellerBottomAppBar({Key? key}) : super(key: key);

  @override
  State<RestSellerBottomAppBar> createState() => _RestSellerBottomAppBarState();
}

class _RestSellerBottomAppBarState extends State<RestSellerBottomAppBar> {
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    SellerDashBoardScreen(),
    SellerChatScreen(),
    ResturentSettingScreen(),
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
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedIndex == 0 ? Colors.blue : Colors.grey,
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
                        color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
                    Text(
                      "Home",
                      style: TextStyle(
                          color:
                              _selectedIndex == 0 ? Colors.blue : Colors.grey),
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
                        color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
                    Text(
                      "Chat",
                      style: TextStyle(
                          color:
                              _selectedIndex == 1 ? Colors.blue : Colors.grey),
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
                        color: _selectedIndex == 2 ? Colors.blue : Colors.grey),
                    Text(
                      "Image",
                      style: TextStyle(
                          color:
                              _selectedIndex == 2 ? Colors.blue : Colors.grey),
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
                        color: _selectedIndex == 3 ? Colors.blue : Colors.grey),
                    Text(
                      "Story",
                      style: TextStyle(
                          color:
                              _selectedIndex == 3 ? Colors.blue : Colors.grey),
                    ),
                  ],
                ),
                label: '',
                backgroundColor:
                    _selectedIndex == 3 ? Colors.blue : Colors.grey),
            BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Icon(Icons.account_circle_outlined,
                        color: _selectedIndex == 4 ? Colors.blue : Colors.grey),
                    Text(
                      "Account",
                      style: TextStyle(
                          color:
                              _selectedIndex == 4 ? Colors.blue : Colors.grey),
                    ),
                  ],
                ),
                label: '',
                backgroundColor:
                    _selectedIndex == 4 ? Colors.blue : Colors.grey),
          ],
        ),
      ),
    );
  }
}

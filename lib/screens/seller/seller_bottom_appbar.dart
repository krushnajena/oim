import 'package:flutter/material.dart';
import 'package:oim/screens/seller/products_list_screen.dart';
import 'package:oim/screens/seller/seller_account_screen.dart';
import 'package:oim/screens/seller/seller_chat_screen.dart';
import 'package:oim/screens/seller/seller_dashboard_screen.dart';
import 'package:oim/screens/seller/story_create_screen.dart';
import 'package:oim/screens/seller/story_list_screen.dart';

class SellerBottomAppBar extends StatefulWidget {
  const SellerBottomAppBar({Key? key}) : super(key: key);

  @override
  State<SellerBottomAppBar> createState() => _SellerBottomAppBarState();
}

class _SellerBottomAppBarState extends State<SellerBottomAppBar> {
  final PageController _pageController = PageController();

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
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined,
                    color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
                label: 'Home',
                backgroundColor:
                    _selectedIndex == 0 ? Colors.blue : Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined,
                    color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
                label: 'Chat',
                backgroundColor:
                    _selectedIndex == 1 ? Colors.blue : Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined,
                    color: _selectedIndex == 2 ? Colors.blue : Colors.grey),
                label: 'Products',
                backgroundColor:
                    _selectedIndex == 2 ? Colors.blue : Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined,
                    color: _selectedIndex == 3 ? Colors.blue : Colors.grey),
                label: 'Story',
                backgroundColor:
                    _selectedIndex == 3 ? Colors.blue : Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined,
                    color: _selectedIndex == 4 ? Colors.blue : Colors.grey),
                label: 'Account',
                backgroundColor:
                    _selectedIndex == 4 ? Colors.blue : Colors.grey),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:oim/screens/user/chat_screen.dart';
import 'package:oim/screens/user/offer_screen.dart';
import 'package:oim/screens/user/story_screen.dart';
import 'package:oim/screens/user/user_account_screen.dart';
import 'package:oim/screens/user/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBottomAppBar extends StatefulWidget {
  const UserBottomAppBar({Key? key}) : super(key: key);

  @override
  State<UserBottomAppBar> createState() => _UserBottomAppBarState();
}

class _UserBottomAppBarState extends State<UserBottomAppBar> {
  String name = "";
  int noofunreadnotifications = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name")!;
    });

    if ((preferences.getString("noofreadnotifications") ?? "") == "") {
      setState(() {
        noofunreadnotifications =
            int.parse(preferences.getInt("noofnotifications").toString());
      });
    } else {
      int noofreadnotifications =
          int.parse(preferences.getString("noofreadnotifications").toString());
      int noofnotifications =
          int.parse(preferences.getInt("noofnotifications").toString());
      setState(() {
        noofunreadnotifications = noofnotifications - noofreadnotifications;
      });
    }
  }

  PageController _pageController = PageController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _screens = [
    UserHomeScreen(),
    ChatScreen(),
    OfferScreen(),
    StoryScreen(),
    UserAccountScreen(),
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
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OfferScreen()));
        },
        child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Image.asset("images/ofic4.png")),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.red,
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
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
                    )
                  ],
                ),
                label: '',
                backgroundColor:
                    _selectedIndex == 0 ? Colors.blue : Colors.grey),
            BottomNavigationBarItem(
                icon: Column(children: [
                  Icon(Icons.chat_outlined,
                      color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
                  Text(
                    "Chat",
                    style: TextStyle(
                        color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
                  )
                ]),
                label: '',
                backgroundColor:
                    _selectedIndex == 1 ? Colors.blue : Colors.grey),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined,
                  color: _selectedIndex == 2 ? Colors.blue : Colors.grey),
              label: '',
            ),
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
                    )
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
                          color:
                              _selectedIndex == 4 ? Colors.blue : Colors.grey),
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
                        color: _selectedIndex == 4 ? Colors.blue : Colors.grey),
                  )
                ],
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:oim/screens/login_screen.dart';
import 'package:oim/screens/signin_screen.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                    ),
                    const Icon(
                      Icons.person_outline_rounded,
                      color: Colors.black45,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 100,
                    width: 100,
                    child: Image.asset("images/oimnew.png"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                    child: Text(
                  "Discover Local Business",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 27,
                      fontWeight: FontWeight.w500),
                )),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    "images/oimp1.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, left: 65, right: 50),
                  child: Text(
                    "Now Search Products from your favourite store online",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen("user")));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: const Center(
                            child: Text(
                              "I'm a Buyer",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen("seller")));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: const Center(
                            child: Text(
                              "I'm a Seller",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

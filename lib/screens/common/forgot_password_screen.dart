import 'package:flutter/material.dart';
import 'package:oim/screens/common/forgot_password_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController txt_mobileno = new TextEditingController();

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  void mobileNoCheck() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotPasswordOTPScreen(txt_mobileno.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back_rounded)),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 110, left: 40, right: 30),
                child: Text(
                  "Enter Phone number for reset password",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 27,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 40, right: 60),
                child: Text(
                  "You shall receive an  SMS with code for verification to reset your password.",
                  style: TextStyle(color: Colors.black38, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    controller: txt_mobileno,
                    autocorrect: true,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '+91 Enter your mobile number',
                      prefixIcon: IconButton(
                        icon: Image.asset(
                          'images/flagnew.jpg',
                          width: 30.0,
                          height: 30.0,
                        ),
                        onPressed: null,
                      ),
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    mobileNoCheck();
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 230, left: 10, right: 10),
                child: Image.asset(
                  "images/simage1.png",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

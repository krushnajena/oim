import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/screens/common/change_password_screen.dart';
import 'package:oim/screens/set_password_screen.dart';
import 'package:otp_autofill/otp_autofill.dart';

class ForgotPasswordOTPScreen extends StatefulWidget {
  final String mobileno;
  const ForgotPasswordOTPScreen(this.mobileno);

  @override
  State<ForgotPasswordOTPScreen> createState() =>
      _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {
  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();
  var otpController = TextEditingController();
  var fourthController = TextEditingController();
  FocusNode secondFocusNode = FocusNode();
  FocusNode thirdFocusNode = FocusNode();
  FocusNode fourthFocusNode = FocusNode();
  late OTPInteractor _otpInteractor;
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  late Timer _timer;
  int _start = 15;

  void startTimer() {
    Timer(const Duration(seconds: 3),
        () => showInSnackBar("An OTP Was sent to your mobile no."));
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.arrow_back_rounded)),
            ),
            const SizedBox(
              height: 40,
            ),
            const Center(
                child: Text(
              "Verification Code",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
            )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80, right: 70),
              child: Text(
                  "Please enter the verification code send to +91" +
                      widget.mobileno,
                  style: const TextStyle(color: Colors.black38, fontSize: 16)),
            ),
            const SizedBox(
              height: 60,
            ),
            Center(
                child: Text(
              _start.toString(),
              style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue),
            )),
            const SizedBox(
              height: 60,
            ),
            Center(
                child: Column(
              children: [
                // OTP Box Start
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // 1 Start
                      Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //   color: whiteColor,
                        //   borderRadius: BorderRadius.circular(0),
                        //   border: Border.all(
                        //     color: Colors.black45,
                        //   ),
                        // ),
                        child: TextField(
                          maxLength: 1,
                          controller: firstController,
                          style: black14MediumTextStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(18.0),
                            // border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (v) {
                            FocusScope.of(context)
                                .requestFocus(secondFocusNode);
                          },
                        ),
                      ),
                      // 1 End
                      const SizedBox(
                        width: 15,
                      ),
                      // 2 Start
                      Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //   color: whiteColor,
                        //   borderRadius: BorderRadius.circular(0),
                        //   border: Border.all(
                        //     color: Colors.black45,
                        //   ),
                        // ),
                        child: TextField(
                          maxLength: 1,
                          focusNode: secondFocusNode,
                          controller: secondController,
                          style: black14MediumTextStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(18.0),
                            // border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (v) {
                            FocusScope.of(context).requestFocus(thirdFocusNode);
                          },
                        ),
                      ),
                      // 2 End
                      const SizedBox(
                        width: 15,
                      ),
                      // 3 Start
                      Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //   color: whiteColor,
                        //   borderRadius: BorderRadius.circular(0),
                        //   border: Border.all(
                        //     color: Colors.black45,
                        //   ),
                        // ),
                        child: TextField(
                          maxLength: 1,
                          focusNode: thirdFocusNode,
                          controller: thirdController,
                          style: black14MediumTextStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(18.0),
                            // border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (v) {
                            FocusScope.of(context)
                                .requestFocus(fourthFocusNode);
                          },
                        ),
                      ),
                      // 3 End
                      const SizedBox(
                        width: 15,
                      ),
                      // 4 Start
                      Container(
                        width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //   color: whiteColor,
                        //   borderRadius: BorderRadius.circular(0),
                        //   border: Border.all(
                        //     color: Colors.black45,
                        //   ),
                        // ),
                        child: TextField(
                          maxLength: 1,
                          focusNode: fourthFocusNode,
                          controller: fourthController,
                          style: black14MediumTextStyle,
                          keyboardType: TextInputType.number,
                          cursorColor: primaryColor,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(18.0),
                            // border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (v) {
                            //loadingDialog();
                          },
                        ),
                      ),
                      // 4 End
                    ],
                  ),
                ),
                // OTP Box End
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(left: 115, top: 20),
              child: InkWell(
                onTap: () {
                  if (_start == 0) {
                    setState(() {
                      _start = 15;
                    });
                    startTimer();
                  }
                },
                child: const Text("Didn't received OTP?",
                    style: TextStyle(color: Colors.black38)),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: SizedBox(
                height: 45,
                width: 250,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (firstController.text +
                            secondController.text +
                            thirdController.text +
                            fourthController.text ==
                        "1234") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangePasswordScreen(widget.mobileno)));
                    } else {
                      Timer(Duration(seconds: 3),
                          () => showInSnackBar("Please Enter A Valid OTP"));
                    }

                    //Navigator.push(context,
                    //  MaterialPageRoute(builder: (context) => Password()));
                  },
                  child: const Text(
                    "Verify",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

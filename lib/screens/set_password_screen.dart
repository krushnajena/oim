import 'package:flutter/material.dart';
import 'package:oim/screens/register_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  final String mobileNo, userType;
  SetPasswordScreen(this.mobileNo, this.userType);

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  bool showPassword = true;
  bool showConfirmPassword = true;

  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;
  TextEditingController txt_password = new TextEditingController();

  TextEditingController txt_confirmpassword = new TextEditingController();
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Icon(Icons.arrow_back_rounded),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 70),
                child: Center(
                    child: Text(
                  "Create a password",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
                )),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 70,
                margin: EdgeInsets.only(left: 13, right: 13),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "You are creating a password for +91(" +
                              widget.mobileNo +
                              ")\nThis will help you login faster next time",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: const TextStyle(
                              color: Colors.black38, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: txt_password,
                      focusNode: passwordFocusNode,
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          FocusScope.of(context)
                              .requestFocus(passwordFocusNode);
                        });
                      },
                      obscureText: showPassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.black38),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () => setState(() {
                                  showPassword = !showPassword;
                                })),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      "At least 6 characters long. Must include a number and a letter.",
                      style: TextStyle(color: Colors.black12, fontSize: 12)),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: txt_confirmpassword,
                      focusNode: confirmPasswordFocusNode,
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          FocusScope.of(context)
                              .requestFocus(confirmPasswordFocusNode);
                        });
                      },
                      obscureText: showConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
                        hintStyle: TextStyle(color: Colors.black38),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () => setState(() {
                                  showConfirmPassword = !showConfirmPassword;
                                })),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 50, right: 20),
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (txt_password.text == txt_confirmpassword.text) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen(
                                  widget.mobileNo,
                                  widget.userType,
                                  txt_password.text)));
                    } else {
                      showInSnackBar("Confirm Password Mismatch");
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AddBusinessHourScreen extends StatefulWidget {
  const AddBusinessHourScreen({Key? key}) : super(key: key);

  @override
  State<AddBusinessHourScreen> createState() => _AddBusinessHourScreenState();
}

class _AddBusinessHourScreenState extends State<AddBusinessHourScreen> {
  bool switchControl = false;
  bool switchControl1 = false;
  bool switchControl2 = false;
  bool switchControl3 = false;
  bool switchControl4 = false;
  bool switchControl5 = false;
  bool switchControl6 = false;
  bool switchControl7 = false;
  var textHolder = 'Closed';

  void toggleSwitch(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
        textHolder = 'Open';
      });
      Row(
        children: [
          Column(
            children: [
              Text(
                "Opens at",
                style: TextStyle(color: Colors.black38),
              ),
              Text(
                "_______________________",
                style: TextStyle(color: Colors.black38),
              ),
            ],
          ),
          Text("-"),
          Column(
            children: [
              Text(
                "Opens at",
                style: TextStyle(color: Colors.black38),
              ),
              Text(
                "_______________________",
                style: TextStyle(color: Colors.black38),
              ),
            ],
          ),
        ],
      );
    } 
    else {
      setState(() {
        switchControl = false;
        textHolder = 'Switch is OFF';
      });
      print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.clear_rounded,
                color: Colors.black87,
              ),
              SizedBox(
                width: 75,
              ),
              Text(
                "Add Business Hours",
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
              SizedBox(
                width: 110,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Row(
              children: [
                Text(
                  "Hours",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                SizedBox(
                  width: 180,
                ),
                Text(
                  "cancel",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                      fontSize: 17),
                ),
                SizedBox(
                  width: 40,
                ),
                Text(
                  "Apply",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.blue),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text("Sunday",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 16)),
              SizedBox(
                width: 50,
              ),
              Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged: (val){
                      setState(() {
                        switchControl1 = !switchControl1;
                      });
                      
                    },
                    value: switchControl1,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.blueAccent,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                  )),
              //Text('$onChanged', style: TextStyle(fontSize: 24),),
              SizedBox(
                width: 5,
              ),
              Text("Closed",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                      fontSize: 15)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text("Monday",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 16)),
              SizedBox(
                width: 45,
              ),
              Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged: (val){
                      setState(() {
                        switchControl2 = !switchControl2;
                      });
                    },
                    value: switchControl2,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.blueAccent,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                  )),
              SizedBox(
                width: 5,
              ),
              Text("Closed",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                      fontSize: 15)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text("Tuesday",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 16)),
              SizedBox(
                width: 43,
              ),
              Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged: (val){
                      setState(() {
                        switchControl3 = val;
                      });
                    },
                    value: switchControl3,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.blueAccent,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                  )),
              SizedBox(
                width: 5,
              ),
              Text("Closed",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                      fontSize: 15)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text("Wednesday",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 16)),
              SizedBox(
                width: 20,
              ),
              Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged:(val){
                      setState(() {
                        switchControl4 = val;
                      });
                    },
                    value: switchControl4,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.blueAccent,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                  )),
              SizedBox(
                width: 5,
              ),
              Text("Closed",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                      fontSize: 15)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text("Thursday",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 16)),
              SizedBox(
                width: 37,
              ),
              Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged:(val){
                      setState(() {
                        switchControl5 = val;
                      });
                    },
                    value: switchControl5,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.blueAccent,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                  )),
              SizedBox(
                width: 5,
              ),
              Text("Closed",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                      fontSize: 15)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text("Friday",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 16)),
              SizedBox(
                width: 60,
              ),
              Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged: (val){
                      setState(() {
                        switchControl6 = val;
                      });
                    },
                    value: switchControl6,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.blueAccent,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                  )),
              SizedBox(
                width: 5,
              ),
              Text("Closed",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                      fontSize: 15)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text("Saturday",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 16)),
              SizedBox(
                width: 40,
              ),
              Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged: (val){
                      setState(() {
                        switchControl7 = val;
                      });
                    },
                    value: switchControl7,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.blueAccent,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                  )),
              SizedBox(
                width: 5,
              ),
              Text("Closed",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                      fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }
}

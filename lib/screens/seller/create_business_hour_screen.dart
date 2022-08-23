import 'package:flutter/material.dart';

class CreateBusinessHourScreen extends StatefulWidget {
  const CreateBusinessHourScreen({Key? key}) : super(key: key);

  @override
  State<CreateBusinessHourScreen> createState() =>
      _CreateBusinessHourScreenState();
}

class _CreateBusinessHourScreenState extends State<CreateBusinessHourScreen> {
  bool switchControl = false;
  var textHolder = 'Closed';
  bool sunday = false;
  bool monday = false;
  bool tuesday = false;
  bool wednessday = false;
  bool thursday = false;
  bool friday = false;
  bool satday = false;

  TimeOfDay sundayselectedTime = TimeOfDay.now();
  TimeOfDay mondayselectedTime = TimeOfDay.now();
  TimeOfDay tuesdayselectedTime = TimeOfDay.now();
  TimeOfDay weddayselectedTime = TimeOfDay.now();
  TimeOfDay thudayselectedTime = TimeOfDay.now();
  TimeOfDay fridayselectedTime = TimeOfDay.now();
  TimeOfDay satdayselectedTime = TimeOfDay.now();

  TimeOfDay sundayselectedTimecl = TimeOfDay.now();
  TimeOfDay mondayselectedTimecl = TimeOfDay.now();
  TimeOfDay tuesdayselectedTimecl = TimeOfDay.now();
  TimeOfDay weddayselectedTimecl = TimeOfDay.now();
  TimeOfDay thudayselectedTimecl = TimeOfDay.now();
  TimeOfDay fridayselectedTimecl = TimeOfDay.now();
  TimeOfDay satdayselectedTimecl = TimeOfDay.now();

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
    } else {
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
        title: Text("Create Business Hour"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  child: Text("Day",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 16)),
                ),

                Text("Status",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 16)),
                //Text('$onChanged', style: TextStyle(fontSize: 24),),
                SizedBox(
                  width: 50,
                ),
                Text("Open At",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 16)),
                SizedBox(
                  width: 15,
                ),
                Text("Close At",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 16)),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  child: Text("Sunday",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 16)),
                ),

                Container(
                  width: 30,
                  child: Transform.scale(
                      scale: 1,
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            sunday = value;
                          });
                        },
                        value: sunday,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.blueAccent,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      )),
                ),

                SizedBox(
                  width: 70,
                ),
                //Text('$onChanged', style: TextStyle(fontSize: 24),),
                sunday
                    ? SizedBox(
                        width: 5,
                      )
                    : Expanded(child: Container()),
                sunday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: sundayselectedTime,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Sunday Opening TIME");
                          if (timeOfDay != null &&
                              timeOfDay != sundayselectedTime) {
                            setState(() {
                              sundayselectedTime = timeOfDay;
                            });
                          }
                        },
                        child: Text(sundayselectedTime.hour.toString() +
                            ":" +
                            sundayselectedTime.minute.toString()),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 10,
                ),
                sunday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: sundayselectedTimecl,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Sunday Closing TIME");
                          if (timeOfDay != null &&
                              timeOfDay != sundayselectedTimecl) {
                            setState(() {
                              sundayselectedTimecl = timeOfDay;
                            });
                          }
                        },
                        child: Text(sundayselectedTimecl.hour.toString() +
                            ":" +
                            sundayselectedTimecl.minute.toString()),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  child: Text("Monday",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 16)),
                ),

                Container(
                  width: 30,
                  child: Transform.scale(
                      scale: 1,
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            monday = value;
                          });
                        },
                        value: monday,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.blueAccent,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      )),
                ),
                //Text('$onChanged', style: TextStyle(fontSize: 24),),
                SizedBox(
                  width: 70,
                ),
                monday
                    ? SizedBox(
                        width: 5,
                      )
                    : Expanded(child: Container()),
                monday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: mondayselectedTime,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Monday Opening TIME");
                          if (timeOfDay != null &&
                              timeOfDay != mondayselectedTime) {
                            setState(() {
                              mondayselectedTime = timeOfDay;
                            });
                          }
                        },
                        child: Text(mondayselectedTime.hour.toString() +
                            ":" +
                            mondayselectedTime.minute.toString()),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 10,
                ),
                monday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: mondayselectedTimecl,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Monday Closing TIME");
                          if (timeOfDay != null &&
                              timeOfDay != mondayselectedTimecl) {
                            setState(() {
                              mondayselectedTimecl = timeOfDay;
                            });
                          }
                        },
                        child: Text(mondayselectedTimecl.hour.toString() +
                            ":" +
                            mondayselectedTimecl.minute.toString()),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  child: Text("Tuesday",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 16)),
                ),

                Container(
                  width: 30,
                  child: Transform.scale(
                      scale: 1,
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            tuesday = value;
                          });
                        },
                        value: tuesday,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.blueAccent,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      )),
                ),
                //Text('$onChanged', style: TextStyle(fontSize: 24),),
                SizedBox(
                  width: 70,
                ),
                tuesday
                    ? SizedBox(
                        width: 5,
                      )
                    : Expanded(child: Container()),
                tuesday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: tuesdayselectedTime,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Tuesday Opening TIME");
                          if (timeOfDay != null &&
                              timeOfDay != tuesdayselectedTime) {
                            setState(() {
                              tuesdayselectedTime = timeOfDay;
                            });
                          }
                        },
                        child: Text(tuesdayselectedTime.hour.toString() +
                            ":" +
                            tuesdayselectedTime.minute.toString()),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 10,
                ),
                tuesday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: tuesdayselectedTimecl,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Tuesday Closing TIME");
                          if (timeOfDay != null &&
                              timeOfDay != tuesdayselectedTimecl) {
                            setState(() {
                              tuesdayselectedTimecl = timeOfDay;
                            });
                          }
                        },
                        child: Text(tuesdayselectedTimecl.hour.toString() +
                            ":" +
                            tuesdayselectedTimecl.minute.toString()),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  child: Text("Wednesday",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 16)),
                ),

                Container(
                  width: 30,
                  child: Transform.scale(
                      scale: 1,
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            wednessday = value;
                          });
                        },
                        value: wednessday,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.blueAccent,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      )),
                ),
                //Text('$onChanged', style: TextStyle(fontSize: 24),),
                SizedBox(
                  width: 70,
                ),
                wednessday
                    ? SizedBox(
                        width: 5,
                      )
                    : Expanded(child: Container()),
                wednessday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: weddayselectedTime,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Wednesday Opening TIME");
                          if (timeOfDay != null &&
                              timeOfDay != weddayselectedTime) {
                            setState(() {
                              weddayselectedTime = timeOfDay;
                            });
                          }
                        },
                        child: Text(weddayselectedTime.hour.toString() +
                            ":" +
                            weddayselectedTime.minute.toString()),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 10,
                ),
                wednessday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: weddayselectedTimecl,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Wednesday Closing TIME");
                          if (timeOfDay != null &&
                              timeOfDay != weddayselectedTimecl) {
                            setState(() {
                              weddayselectedTimecl = timeOfDay;
                            });
                          }
                        },
                        child: Text(weddayselectedTimecl.hour.toString() +
                            ":" +
                            weddayselectedTimecl.minute.toString()),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  child: Text("Thursday",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 16)),
                ),

                Container(
                  width: 30,
                  child: Transform.scale(
                      scale: 1,
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            thursday = value;
                          });
                        },
                        value: thursday,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.blueAccent,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      )),
                ),
                //Text('$onChanged', style: TextStyle(fontSize: 24),),
                SizedBox(
                  width: 70,
                ),
                thursday
                    ? SizedBox(
                        width: 5,
                      )
                    : Expanded(child: Container()),
                thursday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: thudayselectedTime,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Thursday Opening TIME");
                          if (timeOfDay != null &&
                              timeOfDay != thudayselectedTime) {
                            setState(() {
                              thudayselectedTime = timeOfDay;
                            });
                          }
                        },
                        child: Text(thudayselectedTime.hour.toString() +
                            ":" +
                            thudayselectedTime.minute.toString()),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 10,
                ),
                thursday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: thudayselectedTimecl,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Thursday Closing TIME");
                          if (timeOfDay != null &&
                              timeOfDay != thudayselectedTimecl) {
                            setState(() {
                              thudayselectedTimecl = timeOfDay;
                            });
                          }
                        },
                        child: Text(thudayselectedTimecl.hour.toString() +
                            ":" +
                            thudayselectedTimecl.minute.toString()),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 110,
                  child: Text("Friday",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 16)),
                ),

                Container(
                  width: 30,
                  child: Transform.scale(
                      scale: 1,
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            friday = value;
                          });
                        },
                        value: friday,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.blueAccent,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      )),
                ),
                //Text('$onChanged', style: TextStyle(fontSize: 24),),
                SizedBox(
                  width: 70,
                ),
                friday
                    ? SizedBox(
                        width: 5,
                      )
                    : Expanded(child: Container()),

                friday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: fridayselectedTime,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Friday Opening TIME");
                          if (timeOfDay != null &&
                              timeOfDay != fridayselectedTime) {
                            setState(() {
                              fridayselectedTime = timeOfDay;
                            });
                          }
                        },
                        child: Text(fridayselectedTime.hour.toString() +
                            ":" +
                            fridayselectedTime.minute.toString()),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 10,
                ),
                friday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: fridayselectedTimecl,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Friday Closing TIME");
                          if (timeOfDay != null &&
                              timeOfDay != fridayselectedTimecl) {
                            setState(() {
                              fridayselectedTimecl = timeOfDay;
                            });
                          }
                        },
                        child: Text(fridayselectedTimecl.hour.toString() +
                            ":" +
                            fridayselectedTimecl.minute.toString()),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 110,
                  child: Text("Saturday",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 16)),
                ),

                Container(
                  width: 30,
                  child: Transform.scale(
                      scale: 1,
                      child: Switch(
                        onChanged: (value) {
                          setState(() {
                            satday = value;
                          });
                        },
                        value: satday,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.blueAccent,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      )),
                ),
                //Text('$onChanged', style: TextStyle(fontSize: 24),),

                SizedBox(
                  width: 70,
                ),

                satday
                    ? SizedBox(
                        width: 5,
                      )
                    : Expanded(child: Container()),
                satday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: satdayselectedTime,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Saturday Opening TIME");
                          if (timeOfDay != null &&
                              timeOfDay != satdayselectedTime) {
                            setState(() {
                              satdayselectedTime = timeOfDay;
                            });
                          }
                        },
                        child: Text(satdayselectedTime.hour.toString() +
                            ":" +
                            satdayselectedTime.minute.toString()),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 10,
                ),
                satday == true
                    ? ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: satdayselectedTimecl,
                              initialEntryMode: TimePickerEntryMode.input,
                              confirmText: "CONFIRM",
                              cancelText: "NOT NOW",
                              helpText: "Saturday Closing TIME");
                          if (timeOfDay != null &&
                              timeOfDay != satdayselectedTimecl) {
                            setState(() {
                              satdayselectedTimecl = timeOfDay;
                            });
                          }
                        },
                        child: Text(satdayselectedTimecl.hour.toString() +
                            ":" +
                            satdayselectedTimecl.minute.toString()),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  var a = {
                    "sunday": sunday,
                    "sundayopeningtime": sundayselectedTime.hour.toString() +
                        ":" +
                        sundayselectedTime.hour.toString() +
                        sundayselectedTime.period.name,
                    "sundayclosingtime": sundayselectedTimecl.hour.toString() +
                        ":" +
                        sundayselectedTimecl.hour.toString() +
                        sundayselectedTimecl.period.name,
                    "monday": monday,
                    "mondayopeningtime": mondayselectedTime.hour.toString() +
                        ":" +
                        mondayselectedTime.hour.toString() +
                        mondayselectedTime.period.name,
                    "mondayclosingtime": mondayselectedTimecl.hour.toString() +
                        ":" +
                        mondayselectedTimecl.hour.toString() +
                        mondayselectedTimecl.period.name,
                    "tuesday": tuesday,
                    "tuesdayopeningtime": tuesdayselectedTime.hour.toString() +
                        ":" +
                        tuesdayselectedTime.hour.toString() +
                        tuesdayselectedTime.period.name,
                    "tuesdayclosingtime":
                        tuesdayselectedTimecl.hour.toString() +
                            ":" +
                            tuesdayselectedTimecl.hour.toString() +
                            tuesdayselectedTimecl.period.name,
                    "wednessday": wednessday,
                    "wednessdayopeningtime":
                        weddayselectedTime.hour.toString() +
                            ":" +
                            weddayselectedTime.hour.toString() +
                            weddayselectedTime.period.name,
                    "wednessdayclosingtime":
                        weddayselectedTimecl.hour.toString() +
                            ":" +
                            weddayselectedTimecl.hour.toString() +
                            weddayselectedTimecl.period.name,
                    "thursday": thursday,
                    "thursdayopeningtime": thudayselectedTime.hour.toString() +
                        ":" +
                        thudayselectedTime.hour.toString() +
                        thudayselectedTime.period.name,
                    "thursdayclosingtime":
                        thudayselectedTimecl.hour.toString() +
                            ":" +
                            thudayselectedTimecl.hour.toString() +
                            thudayselectedTimecl.period.name,
                    "friday": friday,
                    "fridayopeningtime": fridayselectedTime.hour.toString() +
                        ":" +
                        fridayselectedTime.hour.toString() +
                        fridayselectedTime.period.name,
                    "fridayclosingtime": fridayselectedTimecl.hour.toString() +
                        ":" +
                        fridayselectedTimecl.hour.toString() +
                        fridayselectedTimecl.period.name,
                    "saturday": satday,
                    "saturdayopeningtime": satdayselectedTime.hour.toString() +
                        ":" +
                        satdayselectedTime.hour.toString() +
                        satdayselectedTime.period.name,
                    "saturdayclosingtime":
                        satdayselectedTimecl.hour.toString() +
                            ":" +
                            satdayselectedTimecl.hour.toString() +
                            satdayselectedTimecl.period.name
                  };
                  Navigator.pop(context, a);
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

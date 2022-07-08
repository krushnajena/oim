import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? type;
  String? message;
  String? time;
  String? from;
  String? to;
  String? source;
  Timestamp? messagedon;
  String? msgid;

  bool? issRead;
  String? isDeletdBySeller;
  String? isDeletdByByer;

  String? isBlockedByByer;
  String? isBlockedBySeller;

  MessageModel(
      {this.message,
      this.type,
      this.time,
      this.from,
      this.to,
      this.source,
      this.messagedon,
      this.msgid,
      this.issRead,
      this.isDeletdBySeller,
      this.isDeletdByByer,
      this.isBlockedByByer,
      this.isBlockedBySeller});
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['message'] = this.message;
    map['type'] = this.type;
    map['time'] = this.time;

    map['from'] = this.from;
    map['to'] = this.to;

    map['source'] = this.source;
    map['messagedon'] = this.messagedon;
    map['msgid'] = this.msgid;
    map['issRead'] = this.issRead;
    map['isDeletdBySeller'] = this.isDeletdBySeller!;
    map['isDeletdByByer'] = this.isDeletdByByer!;

    map['isBlockedByByer'] = this.isBlockedByByer!;
    map['isBlockedBySeller'] = this.isBlockedBySeller!;

    return map;
  }

  // named constructor
  MessageModel.fromMap(Map<String, dynamic> map) {
    this.message = map['message'];
    this.type = map['type'];
    this.time = map['time'];

    this.from = map['from'];
    this.to = map['to'];

    this.source = map['source'];
    this.messagedon = map['messagedon'];
    this.msgid = map['msgid'];
    this.issRead = map['issRead'];
    this.isDeletdBySeller = map['isDeletdBySeller'];
    this.isDeletdByByer = map['isDeletdByByer'];

    this.isBlockedByByer = map['isBlockedByByer'];
    this.isBlockedBySeller = map['isBlockedBySeller'];
  }
}

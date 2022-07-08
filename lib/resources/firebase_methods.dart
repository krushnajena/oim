import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oim/models/chat_model.dart';
import 'package:oim/models/message_model.dart';

class FirebaseMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addPlayerToMatch(ChatModel players) async {
    players.lastMessage = "NoMessageAvailableOimAppmaAgg";
    players.isDeletdByByer = "0";
    players.isDeletdBySeller = "0";

    players.isByerUnred = "0";
    players.isSellerUnred = "0";
    var map = players.toMap();

    await firestore.collection("players").add(map);
  }

  Future<void> sentMessage(MessageModel players) async {
    players.isDeletdByByer = "0";
    players.isDeletdBySeller = "0";
    var map = players.toMap();

    await firestore.collection("message").add(map);
    if (players.source == "buyer") {
      await firestore
          .collection("players")
          .doc(players.msgid)
          .update({
            "lastMessage": players.message,
            "isDeletdBySeller": "0",
            "isDeletdByByer": "0",
            "isSellerUnred": "1"
          })
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    } else {
      await firestore
          .collection("players")
          .doc(players.msgid)
          .update({
            "lastMessage": players.message,
            "isDeletdBySeller": "0",
            "isDeletdByByer": "0",
            "isByerUnred": "1"
          })
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    }
  }

  Future<void> updateReadMsgFlag(
      String msgid, String source, String chatid) async {
    print("msgid                " + msgid);
    if (source == "buyer") {
      await firestore
          .collection("players")
          .doc(chatid)
          .update({"isByerUnred": "0"})
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    } else {
      await firestore
          .collection("players")
          .doc(chatid)
          .update({"isSellerUnred": "0"})
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    }
    await firestore
        .collection("message")
        .doc(msgid)
        .update({"issRead": true})
        .then((_) => print('Success'))
        .catchError((error) => print('Failed: $error'));
    ;
  }

  Future<void> deleteMessage(String msgid, String deletedby) async {
    if (deletedby == "buyer") {
      await firestore
          .collection("players")
          .doc(msgid)
          .update({"isDeletdByByer": "1"})
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    } else {
      await firestore
          .collection("players")
          .doc(msgid)
          .update({
            "isDeletdBySeller": "1",
          })
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    }
  }

  Future<void> blockMessage(String msgid, String deletedby) async {
    if (deletedby == "buyer") {
      await firestore
          .collection("players")
          .doc(msgid)
          .update({"isBlockedByByer": "1"})
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    } else {
      await firestore
          .collection("players")
          .doc(msgid)
          .update({
            "isBlockedBySeller": "1",
          })
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    }
  }

  Future<void> unblockMessage(String msgid, String deletedby) async {
    if (deletedby == "buyer") {
      await firestore
          .collection("players")
          .doc(msgid)
          .update({"isBlockedByByer": "0"})
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    } else {
      await firestore
          .collection("players")
          .doc(msgid)
          .update({
            "isBlockedBySeller": "0",
          })
          .then((_) => print('Success'))
          .catchError((error) => print('Failed: $error'));
    }
  }
}

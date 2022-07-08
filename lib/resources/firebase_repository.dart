import 'package:firebase_auth/firebase_auth.dart';
import 'package:oim/models/chat_model.dart';
import 'package:oim/models/message_model.dart';
import 'package:oim/resources/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<void> addPlayerToMatchDb(ChatModel players) =>
      _firebaseMethods.addPlayerToMatch(players);

  Future<void> sendMessageDb(MessageModel players) =>
      _firebaseMethods.sentMessage(players);
  Future<void> updateReadMsgFlag(String id, String source, String chatid) =>
      _firebaseMethods.updateReadMsgFlag(id, source, chatid);

  Future<void> deleteMessage(String msgid, String deletedby) =>
      _firebaseMethods.deleteMessage(msgid, deletedby);

  Future<void> blockMessage(String msgid, String deletedby) =>
      _firebaseMethods.blockMessage(msgid, deletedby);

  Future<void> unblockMessage(String msgid, String deletedby) =>
      _firebaseMethods.unblockMessage(msgid, deletedby);
}

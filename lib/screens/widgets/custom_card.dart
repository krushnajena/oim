import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';

import 'package:oim/models/chat_model.dart';
import 'package:oim/screens/seller/newchatseller.dart';
import 'package:oim/screens/seller/seller_chat_message_screen.dart';
import 'package:oim/screens/user/chat_message_screen.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {required this.chatModel,
      required this.sourchat,
      required this.userType});

  final ChatModel chatModel;
  final ChatModel sourchat;
  final String userType;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (userType == "seller") {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (contex) => SellerChatnew()

                  // SellerChatMessageScreen(
                  //       chatModel: chatModel,
                  //       sourchat: sourchat,
                  //     )
                  ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (contex) =>
                      ChatMessage_Screen("", "", "", "", "", "")));
        }
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Image.network(
                baseUrl + chatModel.productlogo!,
                color: Colors.white,
                height: 36,
                width: 36,
              ),
              backgroundColor: Colors.blueGrey,
            ),
            title: Text(
              chatModel.productname!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.done_all),
                SizedBox(
                  width: 3,
                ),
                Text(
                  chatModel.sellername!,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:oim/constants/urls.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard(
      {Key? key,
      this.message,
      this.time,
      required this.isRead,
      this.messageType})
      : super(key: key);
  final String? message;
  final String? time;
  final bool isRead;
  final String? messageType;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45, minWidth: 150),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.blue[200],
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ),
                child: messageType == "text"
                    ? Text(
                        message!,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    : Container(
                        height: 120,
                        width: 120,
                        child: Image.network(baseUrl + message.toString()),
                      ),
              ),
              Positioned(
                bottom: 4,
                right: 5,
                child: Row(
                  children: [
                    Text(
                      time!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    Icon(
                      Icons.done_all,
                      size: 20,
                      color: isRead ? Colors.blue : Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grpc_chat/constants.dart';
import 'package:grpc_chat/models/chat_message.dart';
import 'package:grpc_chat/services/chat_service.dart';

class MessagesScreen extends StatefulWidget {
  final ChatService service;

  const MessagesScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<ChatMessage>(
            stream: widget.service.recieveMessage(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                messages.add(snapshot.data!);
              }
              return Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) =>
                        MessageWidget(message: messages[index]),
                  ),
                ),
              );
            }),
          )),
          ChatInputWidget(
            onSubmit: (message) {
              if (message != null && message != "") {
                widget.service.sendMessage(message);
              }
            },
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final ChatMessage message;

  const MessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            CircleAvatar(
              radius: 20,
              child: Container(
                child: Text(message.sender.name.toUpperCase().substring(0, 1)),
              ),
            ),
            SizedBox(width: kDefaultPadding / 2),
          ],
          TextMessageWidget(message: message),
        ],
      ),
    );
  }
}

class TextMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const TextMessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.75,
          vertical: kDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(message!.isSender ? 1 : 0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isSender
                ? Colors.white
                : Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
      ),
    );
  }
}

class ChatInputWidget extends StatelessWidget {
  final ValueChanged<String?>? onSubmit;

  const ChatInputWidget({Key? key, this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    String? message;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          message = text;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: kPrimaryColor),
                      onPressed: () {
                        controller.clear();
                        if (onSubmit != null) {
                          onSubmit!(message);
                        }
                        message = null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

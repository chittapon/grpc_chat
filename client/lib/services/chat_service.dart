import 'package:grpc_chat/generated/service.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:grpc_chat/models/chat_message.dart';

class ChatService {
  User user = User();
  static BroadcastClient client = BroadcastClient(
    ClientChannel(
      Platform.isAndroid ? "10.0.2.2" : "localhost",
      port: 8080,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    ),
  );

  ChatService({required String name}) {
    user
      ..clearName()
      ..name = name
      ..clearId()
      ..id = sha256.convert(utf8.encode(user.name)).toString();
  }

  Future<Close> sendMessage(String body) async {
    return client.broadcastMessage(
      Message()
        ..id = user.id
        ..content = body
        ..timestamp = DateTime.now().toIso8601String()
        ..from = user,
    );
  }

  Stream<ChatMessage> recieveMessage() async* {
    Connect connect = Connect()
      ..user = user
      ..active = true;

    await for (Message msg in client.createStream(connect)) {
      yield ChatMessage(
          text: msg.content,
          isSender: msg.from.id == user.id,
          sender: msg.from);
    }
  }
}

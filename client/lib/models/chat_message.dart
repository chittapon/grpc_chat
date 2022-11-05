import 'package:grpc_chat/generated/service.pb.dart';

class ChatMessage {
  final String text;
  final bool isSender;
  final User sender;

  ChatMessage({
    required this.text,
    required this.isSender,
    required this.sender,
  });
}

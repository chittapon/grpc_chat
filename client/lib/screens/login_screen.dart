import 'package:flutter/material.dart';
import 'package:grpc_chat/components/primary_button.dart';
import 'package:grpc_chat/constants.dart';
import 'package:grpc_chat/main.dart';
import 'package:grpc_chat/screens/messages_screen.dart';
import 'package:grpc_chat/services/chat_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Type username",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: kDefaultPadding),
                  ),
                ),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              PrimaryButton(
                text: "Sign In",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagesScreen(
                      service: ChatService(name: controller.text),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

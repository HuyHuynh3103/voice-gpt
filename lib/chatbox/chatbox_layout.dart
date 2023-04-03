import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import "package:uuid/uuid.dart";
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:voice_gpt/common/colors.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatBoxLayout extends StatefulWidget {
  @override
  State<ChatBoxLayout> createState() => _ChatBoxLayoutState();
}

class _ChatBoxLayoutState extends State<ChatBoxLayout> {
  final List<types.Message> _messages = [];
  final _user = types.User(id: const Uuid().v4());
  late OpenAI openAI;
  final tController = StreamController<CTResponse?>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: const DefaultChatTheme(
          inputTextColor: tBlackColor,
          inputBackgroundColor: tGreyLightColor,
          inputBorderRadius: BorderRadius.all(Radius.circular(20)),
          inputMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          inputPadding: EdgeInsets.all(10),
          
          inputTextDecoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Start typing or speaking...',
            hintStyle: TextStyle(
              color: tBlackColor,
              fontSize: 20,
            ),
          ),
        )
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);
  }
}

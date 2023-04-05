import 'dart:async';

import 'package:flutter/material.dart';
import "package:uuid/uuid.dart";
import 'package:voice_gpt/utils/app_theme.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:voice_gpt/common/constants.dart';

class ChatBoxLayout extends StatefulWidget {
  @override
  State<ChatBoxLayout> createState() => _ChatBoxLayoutState();
}

class _ChatBoxLayoutState extends State<ChatBoxLayout> {
  AppTheme theme = LightTheme();
  bool isDarkTheme = false;
  late OpenAI openAI;
  late ChatController _chatController;

  @override
  void initState() {
    super.initState();
    openAI = OpenAI.instance.build(
      token: FlutterConfig.get('OPENAI_API_KEY'),
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 5),
      ),
      isLog: true,
    );

    _chatController = ChatController(
      initialMessageList: [],
      scrollController: ScrollController(
        keepScrollOffset: true,
      ),
      chatUsers: [user, bot],
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  Future<ChatCTResponse?> _openAIChatCompletion() async {
    final messages = _chatController.initialMessageList
        .map((e) => Map.of({
              "role": e.sendBy == user.id ? "user" : "assistant",
              "content": e.message
            }))
        .toList();
    final newMessageId = const Uuid().v4();
    final request = ChatCompleteText(
      messages: messages,
      maxToken: 200,
      model: ChatModel.ChatGptTurbo0301Model,
    );
    final response = await openAI.onChatCompletion(request: request);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        currentUser: user,
        chatController: _chatController,
        onSendTap: _onSendTap,
        chatViewState: ChatViewState.hasMessages,
        chatViewStateConfig: ChatViewStateConfiguration(
          loadingWidgetConfig: ChatViewStateWidgetConfiguration(
            loadingIndicatorColor: theme.outgoingChatBubbleColor,
          ),
          onReloadButtonTap: () {},
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
          flashingCircleBrightColor: theme.flashingCircleBrightColor,
          flashingCircleDarkColor: theme.flashingCircleDarkColor,
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          messageTimeIconColor: theme.messageTimeIconColor,
          messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: theme.chatHeaderColor,
              fontSize: 17,
            ),
          ),
          backgroundColor: theme.backgroundColor,
        ),
        sendMessageConfig: SendMessageConfiguration(
          imagePickerIconsConfig: ImagePickerIconsConfiguration(
            cameraIconColor: theme.cameraIconColor,
            galleryIconColor: theme.galleryIconColor,
          ),
          replyMessageColor: theme.replyMessageColor,
          defaultSendButtonColor: theme.sendButtonColor,
          replyDialogColor: theme.replyDialogColor,
          replyTitleColor: theme.replyTitleColor,
          textFieldBackgroundColor: theme.textFieldBackgroundColor,
          closeIconColor: theme.closeIconColor,
          textFieldConfig: TextFieldConfiguration(
            textStyle: TextStyle(color: theme.textFieldTextColor),
          ),
          micIconColor: theme.replyMicIconColor,
          voiceRecordingConfiguration: VoiceRecordingConfiguration(
            backgroundColor: theme.waveformBackgroundColor,
            recorderIconColor: theme.recordIconColor,
            waveStyle: WaveStyle(
              showMiddleLine: false,
              waveColor: theme.waveColor ?? Colors.white,
              extendWaveform: true,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSendTap(String message, ReplyMessage replyMessage,
      MessageType messageType) async {
    final newMessage = Message(
      id: const Uuid().v4(),
      message: message,
      createdAt: DateTime.now(),
      sendBy: user.id,
      replyMessage: replyMessage,
      messageType: messageType,
    );
    _chatController.addMessage(newMessage);
    // conver message type to list<mapped>
    // chat complete
    final response = await _openAIChatCompletion();
    if (response != null) {
      final newMessage = Message(
        id: const Uuid().v4(),
        message: response.choices[0].message.content,
        createdAt: DateTime.now(),
        sendBy: bot.id,
        replyMessage: replyMessage,
        messageType: messageType,
      );
      _chatController.addMessage(newMessage);
    }
  }
}

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:voice_gpt/models/message_model.dart';

class ChatGptRepository {
  static final ChatGptRepository _instance = ChatGptRepository._internal();
  factory ChatGptRepository() => _instance;
  ChatGptRepository._internal();
  late OpenAI openAI;
  void init() {
    openAI = OpenAI.instance.build(
      token: FlutterConfig.get('OPENAI_API_KEY'),
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 20),
      ),
      isLog: true,
    );
  }

  Future<ChatCTResponse?> generate(
    List<Message> messageList,
  ) async {
    final messages = messageList
        .map((e) => Map.of(
            {"role": e.isSender ? "user" : "assistant", "content": e.content}))
        .toList();
    final request = ChatCompleteText(
      messages: messages,
      maxToken: 200,
      model: ChatModel.ChatGptTurbo0301Model,
    );
    final response = await openAI.onChatCompletion(request: request);
    return response;
  }
}

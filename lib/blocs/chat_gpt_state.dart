import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:voice_gpt/models/message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messageList;
  ChatLoaded(this.messageList);
}

class MessageSent extends ChatState {
  final Message message;
  MessageSent(this.message);
}

class GenerateSuccess extends ChatState {
  final ChatCTResponse response;
  GenerateSuccess(this.response);
}

class ChatFailure extends ChatState {
  final String error;
  ChatFailure(this.error);
}

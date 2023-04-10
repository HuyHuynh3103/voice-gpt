import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:voice_gpt/models/message_model.dart';

enum ChatStatus {
  initialLoaded,
  gptGenerated,
  gptGenerating,
}

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messageList;
  ChatStatus status;
  ChatLoaded(this.messageList, {this.status = ChatStatus.initialLoaded});
}

class MessageSent extends ChatState {
  final Message message;
  MessageSent(this.message);
}

class ChatFailure extends ChatState {
  final String error;
  ChatFailure(this.error);
}

// create a bloc for add new messages

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_gpt/blocs/chat_gpt/chat_gpt_event.dart';
import 'package:voice_gpt/blocs/chat_gpt/chat_gpt_state.dart';
import 'package:voice_gpt/models/message_model.dart';
import 'package:voice_gpt/repository/chat_gpt.dart';
import 'package:voice_gpt/repository/local_storage.dart';

class ChatGptBloc extends Bloc<ChatEvent, ChatState> {
  final ChatGptRepository chatGptRepository;
  final LocalStorage localStorage;
  ChatGptBloc({
    required this.chatGptRepository,
    required this.localStorage,
  }) : super(ChatInitial()) {
    on<LoadInitialMessage>(_mapLoadChatToState);
    on<SendMessage>(_mapSendMessageToState);

    add(const LoadInitialMessage());
  }

  Future<void> _mapLoadChatToState(
      LoadInitialMessage event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await localStorage.loadMessages();
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _mapSendMessageToState(
      SendMessage event, Emitter<ChatState> emit) async {
    try {
      final current = state;
      final List<Message> messageList =
          current is ChatLoaded ? current.messageList : [];
      final sendMessage = Message(
        id: const Uuid().v4(),
        content: event.message,
        isSender: true,
        createdAt: DateTime.now(),
      );

      final updateMessageList = [...messageList, sendMessage];
      Message loadingMessage = Message(
          id: const Uuid().v4(),
          isSender: false,
          content: "Loading...",
          isTyping: true,
          createdAt: DateTime.now());
      final loadingMessageList = [...updateMessageList, loadingMessage];
      emit(ChatLoaded(loadingMessageList, status: ChatStatus.gptGenerating));

      final response = await chatGptRepository.generate(updateMessageList);
      final botMessage = Message(
        id: const Uuid().v4(),
        isSender: false,
        createdAt: DateTime.now(),
      );
      if (response != null) {
        botMessage.content = response.choices[0].message.content;
      } else {
        botMessage.content = "I'm sorry, I don't understand";
        botMessage.isError = true;
      }
      final responseMessageList = [
        ...updateMessageList,
        botMessage,
      ];
      await localStorage.saveMessages(responseMessageList);
      emit(ChatLoaded(responseMessageList, status: ChatStatus.gptGenerated));
    } catch (e) {
      print(e.toString());
      emit(ChatFailure(e.toString()));
    }
  }
}

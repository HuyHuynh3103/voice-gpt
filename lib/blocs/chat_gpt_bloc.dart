// create a bloc for add new messages

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_gpt/blocs/chat_gpt_event.dart';
import 'package:voice_gpt/blocs/chat_gpt_state.dart';
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
    emit(ChatLoading());
    try {
      final current = state;
      final List<Message> messageList =
          current is ChatLoaded ? current.messageList : [];
      final sendMessage = Message(content: event.message, isSender: true);

      final updateMessageList = [...messageList, sendMessage];
      final response = await chatGptRepository.generate(updateMessageList);
      Message botMessage = Message(
        content: "Sorry, I don't understand",
        isSender: false,
      );
      if (response != null) {
        botMessage = Message(
            content: response.choices[0].message.content, isSender: false);
      }
      updateMessageList.add(botMessage);
      await localStorage.saveMessages(updateMessageList);
      emit(ChatLoaded(updateMessageList));
    } catch (e) {
      print(e.toString());
      emit(ChatFailure(e.toString()));
    }
  }
}

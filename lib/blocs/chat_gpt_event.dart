import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;
  const SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class loadInitialMessage extends ChatEvent {
  const loadInitialMessage();

  @override
  List<Object> get props => [];
}



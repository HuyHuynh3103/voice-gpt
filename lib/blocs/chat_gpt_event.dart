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

class LoadInitialMessage extends ChatEvent {
  const LoadInitialMessage();

  @override
  List<Object> get props => [];
}

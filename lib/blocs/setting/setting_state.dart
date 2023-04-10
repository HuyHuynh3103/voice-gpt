import 'package:equatable/equatable.dart';
import 'package:voice_gpt/common/language.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoaded extends SettingState {
  final bool isAutoTTS;
  final Language currentLanguage;

  const SettingLoaded(this.isAutoTTS, this.currentLanguage);

  @override
  List<Object> get props => [isAutoTTS, currentLanguage];
}


class SettingFailure extends SettingState {
  final String message;

  const SettingFailure(this.message);

  @override
  List<Object> get props => [message];
}
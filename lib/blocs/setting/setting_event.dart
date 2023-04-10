import 'package:equatable/equatable.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class LoadSetting extends SettingEvent {}


class ToggleLanguage extends SettingEvent {
  final String language;

  const ToggleLanguage(this.language);

  @override
  List<Object> get props => [language];
}

class SetHandFree extends SettingEvent {
  final bool isHandFree;

  const SetHandFree(this.isHandFree);

  @override
  List<Object> get props => [isHandFree];
}

class ClearMessages extends SettingEvent {}
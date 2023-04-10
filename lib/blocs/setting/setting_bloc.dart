import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_gpt/blocs/setting/setting_event.dart';
import 'package:voice_gpt/blocs/setting/setting_state.dart';
import 'package:voice_gpt/common/language.dart';
import 'package:voice_gpt/repository/local_storage.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final LocalStorage localStorage;

  SettingBloc({required this.localStorage}) : super(SettingInitial()) {
    on<LoadSetting>(_mapLoadSettingToState);
    on<ToggleLanguage>(_mapChangeLanguageToState);
    on<SetHandFree>(_mapSetHandFreeToState);
    on<ClearMessages>(_mapClearMessagesToState);

    add(LoadSetting());
  }

  Future<void> _mapLoadSettingToState(
      LoadSetting event, Emitter<SettingState> emit) async {
    try {
      final isAutoTTS = await localStorage.isAutoTTS;
      final language = await localStorage.speechLanguage;
      print("isAutoTTS: $isAutoTTS");
      print("language: $language");
      emit(SettingLoaded(isAutoTTS, Language.fromCode(language)));
    } catch (e) {
      emit(SettingFailure(e.toString()));
    }
  }

  Future<void> _mapChangeLanguageToState(
      ToggleLanguage event, Emitter<SettingState> emit) async {
    try {
      await localStorage.saveLanguage(event.language.code);
      emit(
        SettingLoaded(
          await localStorage.isAutoTTS,
          Language.fromCode(await localStorage.speechLanguage),
        ),
      );
    } catch (e) {
      emit(SettingFailure(e.toString()));
    }
  }

  Future<void> _mapSetHandFreeToState(
      SetHandFree event, Emitter<SettingState> emit) async {
    try {
      await localStorage.saveIsAutoTTS(event.isHandFree);
      emit(
        SettingLoaded(
          await localStorage.isAutoTTS,
          Language.fromCode(await localStorage.speechLanguage),
        ),
      );
    } catch (e) {
      emit(SettingFailure(e.toString()));
    }
  }

  Future<void> _mapClearMessagesToState(
      ClearMessages event, Emitter<SettingState> emit) async {
    try {
      await localStorage.clearMessages();
      emit(
        SettingLoaded(
          await localStorage.isAutoTTS,
          Language.fromCode(await localStorage.speechLanguage),
        ),
      );
    } catch (e) {
      emit(SettingFailure(e.toString()));
    }
  }
}

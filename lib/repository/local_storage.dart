// Local Storage

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_gpt/models/message_model.dart';

class LocalStorage {
  final messageKey = "messages";
  final speechLanguageKey = "speechLanguage";
  final isAutoTTSKey = "isAutoTTS";
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() {
    return _instance;
  }
  LocalStorage._internal();
  late SharedPreferences _prefs;
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveMessages(List<Message> messages) async {
    final List<String> messageList = messages
        .where((element) => !element.isError)
        .map((e) => jsonEncode(e.toJson()))
        .toList();
    await _prefs.setStringList(messageKey, messageList);
  }

  Future<List<Message>> loadMessages() async {
    print("loadMessages");
    final List<String>? messageList = _prefs.getStringList(messageKey);
    print(messageList);
    if (messageList != null) {
      return messageList.map((e) => Message.fromJson(json.decode(e))).toList();
    }
    return [];
  }

  Future<String> get speechLanguage async {
    return _prefs.getString(speechLanguageKey) ?? "en-US";
  }

  Future<bool> saveLanguage(String language) async {
    return _prefs.setString(speechLanguageKey, language);
  }

  Future<bool> get isAutoTTS async {
    return _prefs.getBool(isAutoTTSKey) ?? false;
  }

  Future<bool> saveIsAutoTTS(bool isAutoTTS) async {
    return _prefs.setBool(isAutoTTSKey, isAutoTTS);
  }

  Future<void> clearMessages() async {
    // clear all messages in local storage
    await _prefs.remove(messageKey);
  }
}

// Local Storage

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_gpt/models/message_model.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() {
    return _instance;
  }
  LocalStorage._internal();
  final key = "messages";
  late SharedPreferences _prefs;
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveMessages(List<Message> messages) async {
    final List<String> messageList = messages
        .where((element) => !element.isError)
        .map((e) => jsonEncode(e.toJson()))
        .toList();
    await _prefs.setStringList(key, messageList);
  }

  Future<List<Message>> loadMessages() async {
    print("loadMessages");
    final List<String>? messageList = _prefs.getStringList(key);
    print(messageList);
    if (messageList != null) {
      return messageList.map((e) => Message.fromJson(json.decode(e))).toList();
    }
    return [];
  }
}

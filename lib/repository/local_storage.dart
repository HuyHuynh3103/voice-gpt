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

  late SharedPreferences _prefs;
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveMessages(List<Message> messages) async {
    final List<String> messageList =
        messages.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList("messages", messageList);
  }

  Future<List<Message>> loadMessages() async {
    final List<String>? messageList =
        _prefs.getStringList("messages");
    if (messageList != null) {
      return messageList.map((e) => Message.fromJson(json.decode(e))).toList();
    }
    return [];
  }
}

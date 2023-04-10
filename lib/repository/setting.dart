import 'package:flutter/cupertino.dart';
import 'package:voice_gpt/repository/local_storage.dart';

class Setting extends ChangeNotifier {
  final LocalStorage localStorage = LocalStorage();

  bool _isAutoTTS = false;
  String _currentLanguage = "en-US";

  bool get isAutoTTS => _isAutoTTS;
  String get currentLanguage => _currentLanguage;

  void toggleLanguage(String language) {
    _currentLanguage = language;
    localStorage.saveLanguage(_currentLanguage);
    notifyListeners();
  }

  void loadLanguage() async {
    String? languageSaved = await localStorage.currentSpeechLanguage;

    if (languageSaved != null) {
      _currentLanguage = languageSaved;
      notifyListeners();
    }
  }

  void toggleAutoTTS() {
    _isAutoTTS = !_isAutoTTS;
    localStorage.saveIsAutoTTS(_isAutoTTS);
    notifyListeners();
  }

  void loadIsAutoTTS() async {
    bool? autoTTSSaved = await localStorage.isAutoTTS;

    if (autoTTSSaved != null) {
      _isAutoTTS = autoTTSSaved;
      notifyListeners();
    }
  }

  void clearMessages() async {
    await localStorage.clearMessages();
  }
}

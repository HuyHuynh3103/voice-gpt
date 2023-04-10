// define list of languages
List<Language> languages = [
  Language('English', 'en-US', 'assets/countries/us.png'),
  Language('Việt Nam', 'vi-VN', 'assets/countries/vn.png'),
];

// define class Language
class Language {
  final String name;
  final String code;
  final String flag;

  Language(this.name, this.code, this.flag);

  static Language fromCode(String code) {
    return languages.firstWhere((element) => element.code == code);
  }
}

// define list of languages
List<Language> languages = [
  Language('System', 'default'),
  Language('Francais', 'fr_FR'),
  Language('English', 'en_US'),
  Language('Việt Nam', 'vi_VN'),
];

// define class Language
class Language {
  final String name;
  final String code;

  Language(this.name, this.code);
}

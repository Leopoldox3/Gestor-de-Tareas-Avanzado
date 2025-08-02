class Country {
  final String code;
  final String name;
  final String? emoji;
  final String? capital;
  final List<String> languages;

  const Country({
    required this.code,
    required this.name,
    this.emoji,
    this.capital,
    this.languages = const [],
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['code'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String?,
      capital: json['capital'] as String?,
      languages:
          (json['languages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'emoji': emoji,
      'capital': capital,
      'languages': languages,
    };
  }
}

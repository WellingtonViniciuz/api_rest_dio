class Pokemon {
  const Pokemon({required this.name, required this.detailsUrl});

  final String name;
  final String detailsUrl;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'] as String,
      detailsUrl: json['url'] as String,
    );
  }

  String get formattedName => name.replaceRange(0, 1, name[0].toUpperCase());
}

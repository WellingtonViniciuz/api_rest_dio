class PokemonDetails {
  const PokemonDetails({
    required this.heightInMeters,
    required this.weightInKilograms,
    this.imageUrl,
  });

  final double heightInMeters;
  final double weightInKilograms;
  final String? imageUrl;

  factory PokemonDetails.fromJson(Map<String, dynamic> json) {
    final sprites = Map<String, dynamic>.from(json['sprites'] as Map);
    final other = Map<String, dynamic>.from(sprites['other'] as Map);
    final officialArtwork = Map<String, dynamic>.from(
      other['official-artwork'] as Map,
    );

    return PokemonDetails(
      heightInMeters: (json['height'] as num) / 10,
      weightInKilograms: (json['weight'] as num) / 10,
      imageUrl:
          officialArtwork['front_default'] as String? ??
          sprites['front_default'] as String?,
    );
  }
}

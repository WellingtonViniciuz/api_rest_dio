import 'package:dio/dio.dart';

import '../models/pokemon.dart';
import '../models/pokemon_details.dart';

class PokemonApi {
  PokemonApi({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<List<Pokemon>> fetchPokemons({int limit = 151}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'https://pokeapi.co/api/v2/pokemon',
      queryParameters: {'limit': limit},
    );
    final results = response.data!['results'] as List<dynamic>;

    return results
        .map(
          (pokemon) =>
              Pokemon.fromJson(Map<String, dynamic>.from(pokemon as Map)),
        )
        .toList();
  }

  Future<PokemonDetails> fetchDetails(String url) async {
    final response = await _dio.get<Map<String, dynamic>>(url);
    return PokemonDetails.fromJson(response.data!);
  }
}

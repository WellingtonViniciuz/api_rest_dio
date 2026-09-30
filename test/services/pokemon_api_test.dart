import 'dart:convert';
import 'dart:typed_data';

import 'package:api_rest_dio/services/pokemon_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAdapter implements HttpClientAdapter {
  MockAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('PokemonApi', () {
    test('fetchPokemons retorna lista de pokemons corretamente', () async {
      final dio = Dio();
      dio.httpClientAdapter = MockAdapter((options) async {
        expect(options.path, 'https://pokeapi.co/api/v2/pokemon');
        expect(options.queryParameters['limit'], 151);

        final responsePayload = {
          'results': [
            {'name': 'bulbasaur', 'url': 'https://pokeapi.co/api/v2/pokemon/1/'},
            {'name': 'ivysaur', 'url': 'https://pokeapi.co/api/v2/pokemon/2/'},
          ],
        };

        return ResponseBody.fromString(
          jsonEncode(responsePayload),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final api = PokemonApi(dio: dio);
      final pokemons = await api.fetchPokemons();

      expect(pokemons.length, 2);
      expect(pokemons[0].name, 'bulbasaur');
      expect(pokemons[0].detailsUrl, 'https://pokeapi.co/api/v2/pokemon/1/');
      expect(pokemons[1].name, 'ivysaur');
      expect(pokemons[1].detailsUrl, 'https://pokeapi.co/api/v2/pokemon/2/');
    });

    test('fetchPokemons respeita parametro limit customizado', () async {
      final dio = Dio();
      dio.httpClientAdapter = MockAdapter((options) async {
        expect(options.queryParameters['limit'], 10);

        final responsePayload = {
          'results': [
            {'name': 'charmander', 'url': 'https://pokeapi.co/api/v2/pokemon/4/'},
          ],
        };

        return ResponseBody.fromString(
          jsonEncode(responsePayload),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final api = PokemonApi(dio: dio);
      final pokemons = await api.fetchPokemons(limit: 10);

      expect(pokemons.length, 1);
      expect(pokemons[0].name, 'charmander');
    });

    test('fetchDetails retorna detalhes do pokemon corretamente', () async {
      final dio = Dio();
      dio.httpClientAdapter = MockAdapter((options) async {
        expect(options.path, 'https://pokeapi.co/api/v2/pokemon/25/');

        final responsePayload = {
          'height': 4,
          'weight': 60,
          'sprites': {
            'front_default': 'https://example.com/pikachu.png',
            'other': {
              'official-artwork': {
                'front_default': 'https://example.com/pikachu-art.png',
              },
            },
          },
        };

        return ResponseBody.fromString(
          jsonEncode(responsePayload),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final api = PokemonApi(dio: dio);
      final details = await api.fetchDetails('https://pokeapi.co/api/v2/pokemon/25/');

      expect(details.heightInMeters, 0.4);
      expect(details.weightInKilograms, 6.0);
      expect(details.imageUrl, 'https://example.com/pikachu-art.png');
    });

    test('fetchPokemons propaga excecao quando dio falha', () async {
      final dio = Dio();
      dio.httpClientAdapter = MockAdapter((options) async {
        return ResponseBody.fromString(
          'Not Found',
          404,
          headers: {
            Headers.contentTypeHeader: [Headers.textPlainContentType],
          },
        );
      });

      final api = PokemonApi(dio: dio);

      expect(() => api.fetchPokemons(), throwsA(isA<DioException>()));
    });
  });
}

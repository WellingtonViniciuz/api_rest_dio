import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokemon_api.dart';
import 'pokemon_details_screen.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key, this.pokemonApi});

  final PokemonApi? pokemonApi;

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late final PokemonApi _pokemonApi;
  List<Pokemon> _pokemons = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pokemonApi = widget.pokemonApi ?? PokemonApi();
    _loadPokemons();
  }

  Future<void> _loadPokemons() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pokemons = await _pokemonApi.fetchPokemons();
      if (!mounted) return;
      setState(() {
        _pokemons = pokemons;
        _isLoading = false;
      });
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Falha na rede ou servidor: ${error.message}';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ocorreu um erro inesperado.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex - Primeira Geração')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.red));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPokemons,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _pokemons.length,
      itemBuilder: (context, index) {
        final pokemon = _pokemons[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red.shade100,
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              pokemon.formattedName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => PokemonDetailsScreen(pokemon: pokemon),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

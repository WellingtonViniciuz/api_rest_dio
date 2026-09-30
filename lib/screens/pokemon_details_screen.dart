import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../models/pokemon_details.dart';
import '../services/pokemon_api.dart';

class PokemonDetailsScreen extends StatefulWidget {
  const PokemonDetailsScreen({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  final PokemonApi _pokemonApi = PokemonApi();
  PokemonDetails? _details;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final details = await _pokemonApi.fetchDetails(widget.pokemon.detailsUrl);
      if (!mounted) return;
      setState(() {
        _details = details;
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
      appBar: AppBar(title: Text(widget.pokemon.formattedName)),
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
              onPressed: _loadDetails,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    final details = _details!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (details.imageUrl != null)
            Image.network(details.imageUrl!, height: 200, fit: BoxFit.contain),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Informações Principais',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.height),
                    title: const Text('Altura'),
                    trailing: Text(
                      '${details.heightInMeters} m',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.monitor_weight),
                    title: const Text('Peso'),
                    trailing: Text(
                      '${details.weightInKilograms} kg',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

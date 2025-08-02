import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/countries/domain/models/country.dart';
import 'package:todo_list/features/countries/domain/repositories/countries_repository.dart';
import 'package:todo_list/features/countries/presentation/widgets/country_tile.dart';

class CountriesScreen extends ConsumerWidget {
  const CountriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsyncValue = ref.watch(countriesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Países del Mundo'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(countriesProvider);
            },
          ),
        ],
      ),
      body: switch (countriesAsyncValue) {
        AsyncValue<List<Country>>(error: null, value: [...]) =>
          countriesAsyncValue.value!.isEmpty
              ? const Center(
                  child: Text(
                    'No se encontraron países',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Total: ${countriesAsyncValue.value!.length} países',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: countriesAsyncValue.value!.length,
                        itemBuilder: (context, index) {
                          final country = countriesAsyncValue.value![index];
                          return CountryTile(country: country);
                        },
                      ),
                    ),
                  ],
                ),
        AsyncValue<List<Country>>(hasError: true, error: Object()) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                'Error al cargar países',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                countriesAsyncValue.error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(countriesProvider);
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        _ => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Cargando países...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      },
    );
  }
}

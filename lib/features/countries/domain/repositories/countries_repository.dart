import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/countries/domain/models/country.dart';
import 'package:todo_list/features/countries/data/data_sources/countries_graphql_data_source.dart';

abstract class CountriesRepository {
  Future<List<Country>> getCountries();
}

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesDataSource dataSource;

  CountriesRepositoryImpl({required this.dataSource});

  @override
  Future<List<Country>> getCountries() async {
    return await dataSource.getCountries();
  }
}

final countriesRepositoryProvider = Provider<CountriesRepository>(
  (ref) => CountriesRepositoryImpl(
    dataSource: ref.watch(countriesDataSourceProvider),
  ),
);

final countriesProvider = FutureProvider<List<Country>>((ref) async {
  final repository = ref.watch(countriesRepositoryProvider);
  return repository.getCountries();
});

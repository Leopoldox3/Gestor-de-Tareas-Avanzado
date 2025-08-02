import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/countries/domain/models/country.dart';

abstract class CountriesDataSource {
  Future<List<Country>> getCountries();
}

class CountriesGraphQLDataSource implements CountriesDataSource {
  late final GraphQLClient _client;

  CountriesGraphQLDataSource() {
    final HttpLink httpLink = HttpLink('https://countries.trevorblades.com/');

    _client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  @override
  Future<List<Country>> getCountries() async {
    const String query = '''
      query GetCountries {
        countries {
          code
          name
          emoji
          capital
          languages {
            name
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(document: gql(query));

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
      throw Exception(
        'Error fetching countries: ${result.exception.toString()}',
      );
    }

    final List<dynamic> countriesData = result.data?['countries'] ?? [];

    return countriesData.map((countryJson) {
      final languages =
          (countryJson['languages'] as List<dynamic>?)
              ?.map((lang) => lang['name'] as String)
              .toList() ??
          <String>[];

      return Country(
        code: countryJson['code'] as String,
        name: countryJson['name'] as String,
        emoji: countryJson['emoji'] as String?,
        capital: countryJson['capital'] as String?,
        languages: languages,
      );
    }).toList();
  }
}

final countriesDataSourceProvider = Provider<CountriesDataSource>(
  (ref) => CountriesGraphQLDataSource(),
);

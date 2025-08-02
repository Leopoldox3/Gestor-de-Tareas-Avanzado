import 'package:flutter/material.dart';
import 'package:todo_list/features/countries/domain/models/country.dart';

class CountryTile extends StatelessWidget {
  final Country country;

  const CountryTile({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            country.emoji ?? country.code.substring(0, 2),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          country.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Código: ${country.code}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            if (country.capital != null && country.capital!.isNotEmpty)
              Text(
                'Capital: ${country.capital}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            if (country.languages.isNotEmpty)
              Text(
                'Idiomas: ${country.languages.take(2).join(", ")}${country.languages.length > 2 ? "..." : ""}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}

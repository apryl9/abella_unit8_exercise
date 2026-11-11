
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'pick.dart';

const detailOmdbKey = String.fromEnvironment('OMDB_KEY');

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({
    super.key,
    required this.pick,
  });

  @override
  State<PickDetailScreen> createState() =>
      _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<Map<String, dynamic>> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = fetchDetails();
  }

  Future<Map<String, dynamic>> fetchDetails() async {
    final pick = widget.pick;

    if (pick.kind == 'movie') {
      if (detailOmdbKey.isEmpty) {
        throw Exception('OMDb API key is missing.');
      }

      final uri = Uri.https(
        'www.omdbapi.com',
        '/',
        {
          'apikey': detailOmdbKey,
          'i': pick.externalId,
          'plot': 'full',
        },
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Failed to load movie details.');
      }

      final data = jsonDecode(response.body)
          as Map<String, dynamic>;

      if (data['Response'] == 'False') {
        throw Exception(data['Error'] ?? 'Movie not found.');
      }

      return data;
    }

    final workId = pick.externalId.split('/').last;

    final uri = Uri.https(
      'openlibrary.org',
      '/works/$workId.json',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load book details.');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  String _getBookDescription(Map<String, dynamic> data) {
    final description = data['description'];

    if (description is String) {
      return description;
    }

    if (description is Map<String, dynamic>) {
      return description['value']?.toString() ?? '';
    }

    return 'No description available.';
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }

          final data = snapshot.data ?? {};

          final isMovie = pick.kind == 'movie';

          final title = isMovie
              ? data['Title']?.toString() ?? pick.title
              : pick.title;

          final imageUrl = isMovie
              ? data['Poster']?.toString() ?? ''
              : data['covers'] is List &&
                      (data['covers'] as List).isNotEmpty
                  ? 'https://covers.openlibrary.org/b/id/${data['covers'][0]}-L.jpg'
                  : '';

          final summary = isMovie
              ? data['Plot']?.toString() ?? ''
              : _getBookDescription(data);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl.isNotEmpty && imageUrl != 'N/A')
                  Center(
                    child: Image.network(
                      imageUrl,
                      height: 260,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  pick.note,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  summary.isEmpty
                      ? 'No description available.'
                      : summary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

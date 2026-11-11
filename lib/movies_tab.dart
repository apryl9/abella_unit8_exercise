
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const omdbKey = String.fromEnvironment('OMDB_KEY');

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  final TextEditingController _searchController =
      TextEditingController();

  Timer? _debounce;
  Future<List<Map<String, dynamic>>>? _moviesFuture;

  Future<List<Map<String, dynamic>>> searchMovies(
    String query,
  ) async {
    final uri = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        'apikey': omdbKey,
        's': query,
        'type': 'movie',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load movies.');
    }

    final data = jsonDecode(response.body);

    if (data['Response'] == 'False') {
      if (data['Error'] == 'Movie not found!') {
        return [];
      }

      throw Exception(data['Error'] ?? 'Failed to load movies.');
    }

    final results = data['Search'] as List<dynamic>? ?? [];

    return results.map((item) {
      return item as Map<String, dynamic>;
    }).toList();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    if (value.trim().length < 3) {
      setState(() {
        _moviesFuture = null;
      });
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (!mounted) return;

        setState(() {
          _moviesFuture = searchMovies(value.trim());
        });
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'OMDb API key is missing. '
            'Run the app with --dart-define=OMDB_KEY=YOUR_KEY.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search movies',
              hintText: 'Enter at least 3 characters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _moviesFuture == null
                ? const Center(
                    child: Text(
                      'Search for a movie to get started.',
                    ),
                  )
                : FutureBuilder<List<Map<String, dynamic>>>(
                    future: _moviesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                          ),
                        );
                      }

                      final movies = snapshot.data ?? [];

                      if (movies.isEmpty) {
                        return const Center(
                          child: Text('No movies found.'),
                        );
                      }

                      return ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];

                          final id = movie['imdbID'] ?? '';
                          final title = movie['Title'] ?? 'Untitled';
                          final year = movie['Year'] ?? '';
                          final poster = movie['Poster'] ?? '';

                          return ListTile(
                            onTap: () async {
                              final messenger =
                                  ScaffoldMessenger.of(context);

                              await Clipboard.setData(
                                ClipboardData(text: id.toString()),
                              );

                              if (!mounted) return;

                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Movie ID copied: $id',
                                  ),
                                ),
                              );
                            },
                            leading: poster != 'N/A'
                                ? Image.network(
                                    poster,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) =>
                                        const Icon(
                                      Icons.movie,
                                    ),
                                  )
                                : const Icon(Icons.movie),
                            title: Text(title.toString()),
                            subtitle: Text(year.toString()),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

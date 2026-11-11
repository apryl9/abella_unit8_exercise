
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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
                          final title =
                              movie['Title'] ?? 'Untitled';
                          final year = movie['Year'] ?? '';
                          final poster = movie['Poster'] ?? '';

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MovieDetailsPage(
                                    imdbId: id.toString(),
                                  ),
                                ),
                              );
                            },
                            leading: poster != 'N/A' &&
                                    poster.toString().isNotEmpty
                                ? Image.network(
                                    poster.toString(),
                                    width: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) =>
                                        const Icon(Icons.movie),
                                  )
                                : const Icon(Icons.movie),
                            title: Text(title.toString()),
                            subtitle: Text(year.toString()),
                            trailing:
                                const Icon(Icons.chevron_right),
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

class MovieDetailsPage extends StatefulWidget {
  final String imdbId;

  const MovieDetailsPage({
    super.key,
    required this.imdbId,
  });

  @override
  State<MovieDetailsPage> createState() =>
      _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Future<Map<String, dynamic>> _movieFuture;

  @override
  void initState() {
    super.initState();
    _movieFuture = fetchMovieDetails();
  }

  Future<Map<String, dynamic>> fetchMovieDetails() async {
    final uri = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        'apikey': omdbKey,
        'i': widget.imdbId,
        'plot': 'full',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load movie details.');
    }

    final data = jsonDecode(response.body);

    if (data['Response'] == 'False') {
      throw Exception(
        data['Error'] ?? 'Movie details unavailable.',
      );
    }

    return data as Map<String, dynamic>;
  }

  Widget detailRow(String label, dynamic value) {
    final text = value?.toString() ?? '';

    if (text.isEmpty || text == 'N/A') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: text),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _movieFuture,
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
                padding: const EdgeInsets.all(20),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }

          final movie = snapshot.data!;

          final poster = movie['Poster']?.toString() ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (poster.isNotEmpty && poster != 'N/A')
                  Image.network(
                    poster,
                    height: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.movie, size: 120),
                  )
                else
                  const Icon(Icons.movie, size: 120),

                const SizedBox(height: 24),

                Text(
                  movie['Title']?.toString() ?? 'Untitled',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  '${movie['Year'] ?? ''} • '
                  '${movie['Rated'] ?? 'Not rated'}',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Movie Information',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 16),

                detailRow('Genre', movie['Genre']),
                detailRow('Director', movie['Director']),
                detailRow('Writer', movie['Writer']),
                detailRow('Actors', movie['Actors']),
                detailRow('Runtime', movie['Runtime']),
                detailRow('Language', movie['Language']),
                detailRow('Country', movie['Country']),
                detailRow('IMDb Rating', movie['imdbRating']),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Plot',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: Text(
                    movie['Plot']?.toString() ??
                        'No plot available.',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

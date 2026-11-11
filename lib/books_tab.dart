
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'book.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final TextEditingController _searchController =
      TextEditingController();

  Timer? _debounce;
  Future<List<Book>>? _booksFuture;

  Future<List<Book>> searchBooks(String query) async {
    final uri = Uri.https(
      'openlibrary.org',
      '/search.json',
      {
        'q': query,
        'limit': '20',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load books.');
    }

    final data = jsonDecode(response.body);
    final docs = data['docs'] as List<dynamic>;

    return docs.map((item) {
      return Book.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    if (value.trim().length < 3) {
      setState(() {
        _booksFuture = null;
      });
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (!mounted) return;

        setState(() {
          _booksFuture = searchBooks(value.trim());
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search books',
              hintText: 'Enter at least 3 characters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _booksFuture == null
                ? const Center(
                    child: Text(
                      'Search for a book to get started.',
                    ),
                  )
                : FutureBuilder<List<Book>>(
                    future: _booksFuture,
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

                      final books = snapshot.data ?? [];

                      if (books.isEmpty) {
                        return const Center(
                          child: Text('No books found.'),
                        );
                      }

                      return ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetailsPage(book: book),
                                ),
                              );
                            },
                            leading: book.coverId == null
                                ? const Icon(Icons.menu_book)
                                : Image.network(
                                    'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                                    width: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) =>
                                        const Icon(Icons.menu_book),
                                  ),
                            title: Text(book.title),
                            subtitle: Text(
                              '${book.authors.join(', ')}'
                              '${book.firstPublishYear == null ? '' : ' • ${book.firstPublishYear}'}',
                            ),
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

class BookDetailsPage extends StatefulWidget {
  final Book book;

  const BookDetailsPage({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailsPage> createState() =>
      _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late Future<String> _descriptionFuture;

  @override
  void initState() {
    super.initState();
    _descriptionFuture = fetchDescription();
  }

  Future<String> fetchDescription() async {
    final uri = Uri.https(
      'openlibrary.org',
      '${widget.book.id}.json',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      return 'No description available.';
    }

    final data = jsonDecode(response.body);
    final description = data['description'];

    if (description is String && description.isNotEmpty) {
      return description;
    }

    if (description is Map &&
        description['value'] is String) {
      return description['value'];
    }

    return 'No description available.';
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (book.coverId != null)
              Image.network(
                'https://covers.openlibrary.org/b/id/${book.coverId}-L.jpg',
                height: 260,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.menu_book, size: 120),
              )
            else
              const Icon(Icons.menu_book, size: 120),

            const SizedBox(height: 24),

            Text(
              book.title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              book.authors.isEmpty
                  ? 'Unknown author'
                  : book.authors.join(', '),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            if (book.firstPublishYear != null) ...[
              const SizedBox(height: 8),
              Text('First published: ${book.firstPublishYear}'),
            ],

            const SizedBox(height: 28),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About this book',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            FutureBuilder<String>(
              future: _descriptionFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  child: Text(
                    snapshot.data ??
                        'No description available.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

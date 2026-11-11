
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                            onTap: () async {
                              final messenger =
                                  ScaffoldMessenger.of(context);

                              await Clipboard.setData(
                                ClipboardData(text: book.id),
                              );

                              if (!mounted) return;

                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Book ID copied: ${book.id}',
                                  ),
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
                                        const Icon(
                                      Icons.menu_book,
                                    ),
                                  ),
                            title: Text(book.title),
                            subtitle: Text(
                              '${book.authors.join(', ')}'
                              '${book.firstPublishYear == null ? '' : ' • ${book.firstPublishYear}'}',
                            ),
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

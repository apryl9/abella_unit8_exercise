
import 'package:flutter/material.dart';

import 'contentful_pick_source.dart';
import 'pick.dart';
import 'pick_detail_screen.dart';

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  final ContentfulPickSource _pickSource =
      ContentfulPickSource();

  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _picksFuture = _pickSource.fetchPicks();
  }

  Future<void> _refreshPicks() async {
    final future = _pickSource.fetchPicks();

    setState(() {
      _picksFuture = future;
    });

    await future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _picksFuture,
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
              child: Text(
                'Error loading picks: ${snapshot.error}',
              ),
            ),
          );
        }

        final picks = snapshot.data ?? [];

        if (picks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refreshPicks,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 250),
                Center(
                  child: Text('No picks yet.'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshPicks,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];

              return ListTile(
                leading: Icon(
                  pick.kind == 'book'
                      ? Icons.menu_book
                      : Icons.movie,
                ),
                title: Text(pick.title),
                subtitle: Text(
                  pick.kind.toUpperCase(),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PickDetailScreen(pick: pick),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

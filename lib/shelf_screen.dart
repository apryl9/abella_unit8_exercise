
import 'package:flutter/material.dart';

import 'books_tab.dart';
import 'movies_tab.dart';
import 'my_picks_tab.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'My Picks'),
              Tab(text: 'Books'),
              Tab(text: 'Movies'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                const MyPicksTab(),
                const BooksTab(),
                const MoviesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

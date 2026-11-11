
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pick.dart';
import 'pick_source.dart';

const contentfulSpaceId = 'rpj5914w5auz';
const contentfulEnvironment = 'master';

const contentfulToken =
    String.fromEnvironment('CONTENTFUL_TOKEN');

class ContentfulPickSource implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async {
    if (contentfulToken.isEmpty) {
      throw Exception('Contentful API token is missing.');
    }

    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$contentfulSpaceId/environments/'
          '$contentfulEnvironment/entries',
      {
        'access_token': contentfulToken,
        'content_type': 'pick',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load picks: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body)
        as Map<String, dynamic>;

    final items = data['items'] as List<dynamic>? ?? [];

    return items.map((item) {
      return Pick.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
}

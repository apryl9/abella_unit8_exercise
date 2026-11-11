class Book {
  final String id;
  final String title;
  final List<String> authors;
  final int? firstPublishYear;
  final int? coverId;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.firstPublishYear,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['key']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled',
      authors: (json['author_name'] as List<dynamic>?)
              ?.map((author) => author.toString())
              .toList() ??
          [],
      firstPublishYear: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }
}
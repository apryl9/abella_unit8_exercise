
class Pick {
  final String id;
  final String title;
  final String kind;
  final String externalId;
  final String note;

  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  static String readField(dynamic value) {
    if (value is String) {
      return value;
    }

    if (value is Map) {
      return value['en-US']?.toString() ?? '';
    }

    return '';
  }

  factory Pick.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>;
    final sys = json['sys'] as Map<String, dynamic>;

    return Pick(
      id: sys['id']?.toString() ?? '',
      title: readField(fields['title']),
      kind: readField(fields['kind']),
      externalId: readField(fields['externalId']),
      note: readField(fields['note']),
    );
  }
}

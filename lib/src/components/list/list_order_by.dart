class ListOrderBy {
  String field;
  bool descending;

  ListOrderBy({required this.field, this.descending = false});

  Map<String, dynamic> toMap() => {'field': field, 'descending': descending};
}

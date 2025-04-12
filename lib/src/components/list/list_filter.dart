class ListFilter {
  String field;
  String operator;
  dynamic value;

  ListFilter(
      {required this.field, required this.operator, required this.value});

  Map<String, dynamic> toMap() =>
      {'field': field, 'operator': operator, 'value': value};
}

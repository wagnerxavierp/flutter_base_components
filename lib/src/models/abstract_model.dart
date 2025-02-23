import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart' as json_ann;

part 'abstract_model.g.dart';

@json_ann.JsonSerializable()
class AbstractModel {
  @json_ann.JsonKey(name: 'uuid')
  String? uuid;
  @json_ann.JsonKey(name: 'id')
  int? id;
  @json_ann.JsonKey(name: 'name')
  String? name;
  @json_ann.JsonKey(name: 'created_at')
  String? createdAt;
  @json_ann.JsonKey(name: 'updated_at')
  String? updatedAt;
  @json_ann.JsonKey(name: 'action')
  String? action;
  @json_ann.JsonKey(name: 'is_synced')
  int? isSynced;
  @json_ann.JsonKey(name: 'is_active')
  int? isActive;
  @json_ann.JsonKey(name: 'tenant_uuid')
  String? tenantUuid;
  @json_ann.JsonKey(name: 'user_uuid')
  String? userUuid;

  AbstractModel({
    this.uuid,
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.action,
    this.isSynced,
    this.isActive,
    this.tenantUuid,
    this.userUuid,
  });

  factory AbstractModel.fromJson(Map<String, dynamic> json) =>
      _$AbstractModelFromJson(json);

  Map<String, dynamic> toJson() => _$AbstractModelToJson(this);

  String get tableName =>
      _camelCaseToLowerUnderscore("${runtimeType.toString()}Table");

  // String get columns =>
  //     "(${toJson().keys.toList()})".replaceFirst("[", "").replaceFirst("]", "");

  // String get valuesTable =>
  //     "(${toJson().keys.toList().map((e) => "?").toList()})"
  //         .replaceAll("[", "")
  //         .replaceAll("]", "");

  // String get setValues =>
  //     "${toJson().keys.toList().map((e) => "$e = ?").toList()}"
  //         .replaceAll("[", "")
  //         .replaceAll("]", "");

  // List<Variable<Object>> get values =>
  //     toJson().values.toList().map((e) => Variable(e)).toList();

  //Date formated dd/MM/yyyy
  String get createdAtFormated {
    if (createdAt != null) {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(createdAt!));
    }
    return "";
  }

  List<String> get listTilesValues => [name ?? ""];
}

String _camelCaseToLowerUnderscore(String s) {
  var sb = StringBuffer();
  var first = true;
  for (var rune in s.runes) {
    var char = String.fromCharCode(rune);
    if (_isUpperCase(char) && !first) {
      if (char != '_') {
        sb.write('_');
      }
      sb.write(char.toLowerCase());
    } else {
      first = false;
      sb.write(char.toLowerCase());
    }
  }
  return sb.toString();
}

bool _isUpperCase(String s) {
  return s == s.toUpperCase();
}

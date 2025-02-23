// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abstract_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbstractModel _$AbstractModelFromJson(Map<String, dynamic> json) =>
    AbstractModel(
      uuid: json['uuid'] as String?,
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      action: json['action'] as String?,
      isSynced: (json['is_synced'] as num?)?.toInt(),
      isActive: (json['is_active'] as num?)?.toInt(),
      tenantUuid: json['tenant_uuid'] as String?,
      userUuid: json['user_uuid'] as String?,
    );

Map<String, dynamic> _$AbstractModelToJson(AbstractModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'action': instance.action,
      'is_synced': instance.isSynced,
      'is_active': instance.isActive,
      'tenant_uuid': instance.tenantUuid,
      'user_uuid': instance.userUuid,
    };

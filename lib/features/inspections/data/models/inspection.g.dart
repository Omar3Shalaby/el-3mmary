// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InspectionImpl _$$InspectionImplFromJson(Map<String, dynamic> json) =>
    _$InspectionImpl(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      address: json['address'] as String,
      notes: json['notes'] as String?,
      scheduledFrom: json['scheduled_from'] == null
          ? null
          : DateTime.parse(json['scheduled_from'] as String),
      scheduledTo: json['scheduled_to'] == null
          ? null
          : DateTime.parse(json['scheduled_to'] as String),
      status: json['status'] as String? ?? 'scheduled',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$InspectionImplToJson(_$InspectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer_id': instance.customerId,
      'address': instance.address,
      'notes': instance.notes,
      'scheduled_from': instance.scheduledFrom?.toIso8601String(),
      'scheduled_to': instance.scheduledTo?.toIso8601String(),
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
    };

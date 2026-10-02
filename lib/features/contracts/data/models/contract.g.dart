// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContractImpl _$$ContractImplFromJson(Map<String, dynamic> json) =>
    _$ContractImpl(
      id: json['id'] as String,
      inspectionId: json['inspection_id'] as String,
      customerId: json['customer_id'] as String,
      deliveryDate: json['delivery_date'] == null
          ? null
          : DateTime.parse(json['delivery_date'] as String),
      pickupDate: json['pickup_date'] == null
          ? null
          : DateTime.parse(json['pickup_date'] as String),
      pickupAddress: json['pickup_address'] as String?,
      deliveryAddress: json['delivery_address'] as String?,
      status: json['status'] as String? ?? 'active',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ContractImplToJson(_$ContractImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inspection_id': instance.inspectionId,
      'customer_id': instance.customerId,
      'delivery_date': instance.deliveryDate?.toIso8601String(),
      'pickup_date': instance.pickupDate?.toIso8601String(),
      'pickup_address': instance.pickupAddress,
      'delivery_address': instance.deliveryAddress,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
    };

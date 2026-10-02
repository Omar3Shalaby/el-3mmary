// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InspectionItemImpl _$$InspectionItemImplFromJson(Map<String, dynamic> json) =>
    _$InspectionItemImpl(
      id: json['id'] as String,
      inspectionId: json['inspection_id'] as String,
      itemName: json['item_name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$InspectionItemImplToJson(
  _$InspectionItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'inspection_id': instance.inspectionId,
  'item_name': instance.itemName,
  'price': instance.price,
  'quantity': instance.quantity,
  'description': instance.description,
};

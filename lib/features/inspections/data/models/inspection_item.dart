import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_item.freezed.dart';
part 'inspection_item.g.dart';

@freezed
abstract class InspectionItem with _$InspectionItem {
  const factory InspectionItem({
    required String id,
    @JsonKey(name: 'inspection_id') required String inspectionId,
    @JsonKey(name: 'item_name') required String itemName,
    required double price,
  }) = _InspectionItem;

  factory InspectionItem.fromJson(Map<String, dynamic> json) =>
      _$InspectionItemFromJson(json);
}

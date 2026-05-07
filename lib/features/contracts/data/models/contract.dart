import 'package:freezed_annotation/freezed_annotation.dart';

part 'contract.freezed.dart';
part 'contract.g.dart';

@freezed
abstract class Contract with _$Contract {
  const factory Contract({
    required String id,
    @JsonKey(name: 'inspection_id') required String inspectionId,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'delivery_date') DateTime? deliveryDate,
    @JsonKey(name: 'pickup_date') DateTime? pickupDate,
    @Default('active') String status, // active | cancelled
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Contract;

  factory Contract.fromJson(Map<String, dynamic> json) =>
      _$ContractFromJson(json);
}

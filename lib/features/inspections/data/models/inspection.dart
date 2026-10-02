import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection.freezed.dart';
part 'inspection.g.dart';

@freezed
abstract class Inspection with _$Inspection {
  const factory Inspection({
    required String id,
    @JsonKey(name: 'customer_id') required String customerId,
    required String address,
    String? notes,
    @JsonKey(name: 'scheduled_from') DateTime? scheduledFrom,
    @JsonKey(name: 'scheduled_to') DateTime? scheduledTo,
    @Default('scheduled') String status, // scheduled | done | no_contract
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Inspection;

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);
}

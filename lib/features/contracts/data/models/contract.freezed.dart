// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contract.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Contract _$ContractFromJson(Map<String, dynamic> json) {
  return _Contract.fromJson(json);
}

/// @nodoc
mixin _$Contract {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_id')
  String get inspectionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_date')
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'pickup_date')
  DateTime? get pickupDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'pickup_address')
  String? get pickupAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_address')
  String? get deliveryAddress => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError; // active | cancelled
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Contract to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Contract
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContractCopyWith<Contract> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContractCopyWith<$Res> {
  factory $ContractCopyWith(Contract value, $Res Function(Contract) then) =
      _$ContractCopyWithImpl<$Res, Contract>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'inspection_id') String inspectionId,
    @JsonKey(name: 'customer_id') String customerId,
    @JsonKey(name: 'delivery_date') DateTime? deliveryDate,
    @JsonKey(name: 'pickup_date') DateTime? pickupDate,
    @JsonKey(name: 'pickup_address') String? pickupAddress,
    @JsonKey(name: 'delivery_address') String? deliveryAddress,
    String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$ContractCopyWithImpl<$Res, $Val extends Contract>
    implements $ContractCopyWith<$Res> {
  _$ContractCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Contract
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inspectionId = null,
    Object? customerId = null,
    Object? deliveryDate = freezed,
    Object? pickupDate = freezed,
    Object? pickupAddress = freezed,
    Object? deliveryAddress = freezed,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            inspectionId: null == inspectionId
                ? _value.inspectionId
                : inspectionId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            deliveryDate: freezed == deliveryDate
                ? _value.deliveryDate
                : deliveryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            pickupDate: freezed == pickupDate
                ? _value.pickupDate
                : pickupDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            pickupAddress: freezed == pickupAddress
                ? _value.pickupAddress
                : pickupAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryAddress: freezed == deliveryAddress
                ? _value.deliveryAddress
                : deliveryAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContractImplCopyWith<$Res>
    implements $ContractCopyWith<$Res> {
  factory _$$ContractImplCopyWith(
    _$ContractImpl value,
    $Res Function(_$ContractImpl) then,
  ) = __$$ContractImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'inspection_id') String inspectionId,
    @JsonKey(name: 'customer_id') String customerId,
    @JsonKey(name: 'delivery_date') DateTime? deliveryDate,
    @JsonKey(name: 'pickup_date') DateTime? pickupDate,
    @JsonKey(name: 'pickup_address') String? pickupAddress,
    @JsonKey(name: 'delivery_address') String? deliveryAddress,
    String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$ContractImplCopyWithImpl<$Res>
    extends _$ContractCopyWithImpl<$Res, _$ContractImpl>
    implements _$$ContractImplCopyWith<$Res> {
  __$$ContractImplCopyWithImpl(
    _$ContractImpl _value,
    $Res Function(_$ContractImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Contract
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inspectionId = null,
    Object? customerId = null,
    Object? deliveryDate = freezed,
    Object? pickupDate = freezed,
    Object? pickupAddress = freezed,
    Object? deliveryAddress = freezed,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ContractImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        inspectionId: null == inspectionId
            ? _value.inspectionId
            : inspectionId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        deliveryDate: freezed == deliveryDate
            ? _value.deliveryDate
            : deliveryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pickupDate: freezed == pickupDate
            ? _value.pickupDate
            : pickupDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pickupAddress: freezed == pickupAddress
            ? _value.pickupAddress
            : pickupAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryAddress: freezed == deliveryAddress
            ? _value.deliveryAddress
            : deliveryAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContractImpl implements _Contract {
  const _$ContractImpl({
    required this.id,
    @JsonKey(name: 'inspection_id') required this.inspectionId,
    @JsonKey(name: 'customer_id') required this.customerId,
    @JsonKey(name: 'delivery_date') this.deliveryDate,
    @JsonKey(name: 'pickup_date') this.pickupDate,
    @JsonKey(name: 'pickup_address') this.pickupAddress,
    @JsonKey(name: 'delivery_address') this.deliveryAddress,
    this.status = 'active',
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$ContractImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContractImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'inspection_id')
  final String inspectionId;
  @override
  @JsonKey(name: 'customer_id')
  final String customerId;
  @override
  @JsonKey(name: 'delivery_date')
  final DateTime? deliveryDate;
  @override
  @JsonKey(name: 'pickup_date')
  final DateTime? pickupDate;
  @override
  @JsonKey(name: 'pickup_address')
  final String? pickupAddress;
  @override
  @JsonKey(name: 'delivery_address')
  final String? deliveryAddress;
  @override
  @JsonKey()
  final String status;
  // active | cancelled
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Contract(id: $id, inspectionId: $inspectionId, customerId: $customerId, deliveryDate: $deliveryDate, pickupDate: $pickupDate, pickupAddress: $pickupAddress, deliveryAddress: $deliveryAddress, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContractImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inspectionId, inspectionId) ||
                other.inspectionId == inspectionId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.pickupDate, pickupDate) ||
                other.pickupDate == pickupDate) &&
            (identical(other.pickupAddress, pickupAddress) ||
                other.pickupAddress == pickupAddress) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    inspectionId,
    customerId,
    deliveryDate,
    pickupDate,
    pickupAddress,
    deliveryAddress,
    status,
    createdAt,
  );

  /// Create a copy of Contract
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContractImplCopyWith<_$ContractImpl> get copyWith =>
      __$$ContractImplCopyWithImpl<_$ContractImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContractImplToJson(this);
  }
}

abstract class _Contract implements Contract {
  const factory _Contract({
    required final String id,
    @JsonKey(name: 'inspection_id') required final String inspectionId,
    @JsonKey(name: 'customer_id') required final String customerId,
    @JsonKey(name: 'delivery_date') final DateTime? deliveryDate,
    @JsonKey(name: 'pickup_date') final DateTime? pickupDate,
    @JsonKey(name: 'pickup_address') final String? pickupAddress,
    @JsonKey(name: 'delivery_address') final String? deliveryAddress,
    final String status,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$ContractImpl;

  factory _Contract.fromJson(Map<String, dynamic> json) =
      _$ContractImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'inspection_id')
  String get inspectionId;
  @override
  @JsonKey(name: 'customer_id')
  String get customerId;
  @override
  @JsonKey(name: 'delivery_date')
  DateTime? get deliveryDate;
  @override
  @JsonKey(name: 'pickup_date')
  DateTime? get pickupDate;
  @override
  @JsonKey(name: 'pickup_address')
  String? get pickupAddress;
  @override
  @JsonKey(name: 'delivery_address')
  String? get deliveryAddress;
  @override
  String get status; // active | cancelled
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of Contract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContractImplCopyWith<_$ContractImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

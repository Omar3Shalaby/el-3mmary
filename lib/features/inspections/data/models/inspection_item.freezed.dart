// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InspectionItem _$InspectionItemFromJson(Map<String, dynamic> json) {
  return _InspectionItem.fromJson(json);
}

/// @nodoc
mixin _$InspectionItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_id')
  String get inspectionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_name')
  String get itemName => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this InspectionItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InspectionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InspectionItemCopyWith<InspectionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InspectionItemCopyWith<$Res> {
  factory $InspectionItemCopyWith(
    InspectionItem value,
    $Res Function(InspectionItem) then,
  ) = _$InspectionItemCopyWithImpl<$Res, InspectionItem>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'inspection_id') String inspectionId,
    @JsonKey(name: 'item_name') String itemName,
    double price,
    int quantity,
    String? description,
  });
}

/// @nodoc
class _$InspectionItemCopyWithImpl<$Res, $Val extends InspectionItem>
    implements $InspectionItemCopyWith<$Res> {
  _$InspectionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InspectionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inspectionId = null,
    Object? itemName = null,
    Object? price = null,
    Object? quantity = null,
    Object? description = freezed,
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
            itemName: null == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InspectionItemImplCopyWith<$Res>
    implements $InspectionItemCopyWith<$Res> {
  factory _$$InspectionItemImplCopyWith(
    _$InspectionItemImpl value,
    $Res Function(_$InspectionItemImpl) then,
  ) = __$$InspectionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'inspection_id') String inspectionId,
    @JsonKey(name: 'item_name') String itemName,
    double price,
    int quantity,
    String? description,
  });
}

/// @nodoc
class __$$InspectionItemImplCopyWithImpl<$Res>
    extends _$InspectionItemCopyWithImpl<$Res, _$InspectionItemImpl>
    implements _$$InspectionItemImplCopyWith<$Res> {
  __$$InspectionItemImplCopyWithImpl(
    _$InspectionItemImpl _value,
    $Res Function(_$InspectionItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InspectionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inspectionId = null,
    Object? itemName = null,
    Object? price = null,
    Object? quantity = null,
    Object? description = freezed,
  }) {
    return _then(
      _$InspectionItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        inspectionId: null == inspectionId
            ? _value.inspectionId
            : inspectionId // ignore: cast_nullable_to_non_nullable
                  as String,
        itemName: null == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InspectionItemImpl implements _InspectionItem {
  const _$InspectionItemImpl({
    required this.id,
    @JsonKey(name: 'inspection_id') required this.inspectionId,
    @JsonKey(name: 'item_name') required this.itemName,
    required this.price,
    this.quantity = 1,
    this.description,
  });

  factory _$InspectionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InspectionItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'inspection_id')
  final String inspectionId;
  @override
  @JsonKey(name: 'item_name')
  final String itemName;
  @override
  final double price;
  @override
  @JsonKey()
  final int quantity;
  @override
  final String? description;

  @override
  String toString() {
    return 'InspectionItem(id: $id, inspectionId: $inspectionId, itemName: $itemName, price: $price, quantity: $quantity, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InspectionItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inspectionId, inspectionId) ||
                other.inspectionId == inspectionId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    inspectionId,
    itemName,
    price,
    quantity,
    description,
  );

  /// Create a copy of InspectionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InspectionItemImplCopyWith<_$InspectionItemImpl> get copyWith =>
      __$$InspectionItemImplCopyWithImpl<_$InspectionItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InspectionItemImplToJson(this);
  }
}

abstract class _InspectionItem implements InspectionItem {
  const factory _InspectionItem({
    required final String id,
    @JsonKey(name: 'inspection_id') required final String inspectionId,
    @JsonKey(name: 'item_name') required final String itemName,
    required final double price,
    final int quantity,
    final String? description,
  }) = _$InspectionItemImpl;

  factory _InspectionItem.fromJson(Map<String, dynamic> json) =
      _$InspectionItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'inspection_id')
  String get inspectionId;
  @override
  @JsonKey(name: 'item_name')
  String get itemName;
  @override
  double get price;
  @override
  int get quantity;
  @override
  String? get description;

  /// Create a copy of InspectionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InspectionItemImplCopyWith<_$InspectionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

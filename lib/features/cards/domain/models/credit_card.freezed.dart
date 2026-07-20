// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credit_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreditCard _$CreditCardFromJson(Map<String, dynamic> json) {
  return _CreditCard.fromJson(json);
}

/// @nodoc
mixin _$CreditCard {
  String get id => throw _privateConstructorUsedError;
  String get bankName => throw _privateConstructorUsedError;
  String get cardName => throw _privateConstructorUsedError;
  String get cardType =>
      throw _privateConstructorUsedError; // e.g. Visa, Mastercard, Amex, etc.
  String get last4Digits => throw _privateConstructorUsedError;
  String get cardColor =>
      throw _privateConstructorUsedError; // e.g. Carbon, Sapphire, etc.
  double get creditLimit => throw _privateConstructorUsedError;
  int get statementDate => throw _privateConstructorUsedError; // 1-31
  int get dueDate => throw _privateConstructorUsedError; // 1-31
  int get reminderDaysBefore => throw _privateConstructorUsedError;
  double get outstandingAmount => throw _privateConstructorUsedError;
  double get minimumDue => throw _privateConstructorUsedError;
  String get paymentStatus =>
      throw _privateConstructorUsedError; // 'Paid', 'Unpaid', 'Overdue', 'Archived'
  String get notes => throw _privateConstructorUsedError;
  DateTime get createdDate => throw _privateConstructorUsedError;
  DateTime get updatedDate => throw _privateConstructorUsedError;

  /// Serializes this CreditCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreditCardCopyWith<CreditCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreditCardCopyWith<$Res> {
  factory $CreditCardCopyWith(
    CreditCard value,
    $Res Function(CreditCard) then,
  ) = _$CreditCardCopyWithImpl<$Res, CreditCard>;
  @useResult
  $Res call({
    String id,
    String bankName,
    String cardName,
    String cardType,
    String last4Digits,
    String cardColor,
    double creditLimit,
    int statementDate,
    int dueDate,
    int reminderDaysBefore,
    double outstandingAmount,
    double minimumDue,
    String paymentStatus,
    String notes,
    DateTime createdDate,
    DateTime updatedDate,
  });
}

/// @nodoc
class _$CreditCardCopyWithImpl<$Res, $Val extends CreditCard>
    implements $CreditCardCopyWith<$Res> {
  _$CreditCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bankName = null,
    Object? cardName = null,
    Object? cardType = null,
    Object? last4Digits = null,
    Object? cardColor = null,
    Object? creditLimit = null,
    Object? statementDate = null,
    Object? dueDate = null,
    Object? reminderDaysBefore = null,
    Object? outstandingAmount = null,
    Object? minimumDue = null,
    Object? paymentStatus = null,
    Object? notes = null,
    Object? createdDate = null,
    Object? updatedDate = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            bankName: null == bankName
                ? _value.bankName
                : bankName // ignore: cast_nullable_to_non_nullable
                      as String,
            cardName: null == cardName
                ? _value.cardName
                : cardName // ignore: cast_nullable_to_non_nullable
                      as String,
            cardType: null == cardType
                ? _value.cardType
                : cardType // ignore: cast_nullable_to_non_nullable
                      as String,
            last4Digits: null == last4Digits
                ? _value.last4Digits
                : last4Digits // ignore: cast_nullable_to_non_nullable
                      as String,
            cardColor: null == cardColor
                ? _value.cardColor
                : cardColor // ignore: cast_nullable_to_non_nullable
                      as String,
            creditLimit: null == creditLimit
                ? _value.creditLimit
                : creditLimit // ignore: cast_nullable_to_non_nullable
                      as double,
            statementDate: null == statementDate
                ? _value.statementDate
                : statementDate // ignore: cast_nullable_to_non_nullable
                      as int,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as int,
            reminderDaysBefore: null == reminderDaysBefore
                ? _value.reminderDaysBefore
                : reminderDaysBefore // ignore: cast_nullable_to_non_nullable
                      as int,
            outstandingAmount: null == outstandingAmount
                ? _value.outstandingAmount
                : outstandingAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            minimumDue: null == minimumDue
                ? _value.minimumDue
                : minimumDue // ignore: cast_nullable_to_non_nullable
                      as double,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            createdDate: null == createdDate
                ? _value.createdDate
                : createdDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedDate: null == updatedDate
                ? _value.updatedDate
                : updatedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreditCardImplCopyWith<$Res>
    implements $CreditCardCopyWith<$Res> {
  factory _$$CreditCardImplCopyWith(
    _$CreditCardImpl value,
    $Res Function(_$CreditCardImpl) then,
  ) = __$$CreditCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String bankName,
    String cardName,
    String cardType,
    String last4Digits,
    String cardColor,
    double creditLimit,
    int statementDate,
    int dueDate,
    int reminderDaysBefore,
    double outstandingAmount,
    double minimumDue,
    String paymentStatus,
    String notes,
    DateTime createdDate,
    DateTime updatedDate,
  });
}

/// @nodoc
class __$$CreditCardImplCopyWithImpl<$Res>
    extends _$CreditCardCopyWithImpl<$Res, _$CreditCardImpl>
    implements _$$CreditCardImplCopyWith<$Res> {
  __$$CreditCardImplCopyWithImpl(
    _$CreditCardImpl _value,
    $Res Function(_$CreditCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bankName = null,
    Object? cardName = null,
    Object? cardType = null,
    Object? last4Digits = null,
    Object? cardColor = null,
    Object? creditLimit = null,
    Object? statementDate = null,
    Object? dueDate = null,
    Object? reminderDaysBefore = null,
    Object? outstandingAmount = null,
    Object? minimumDue = null,
    Object? paymentStatus = null,
    Object? notes = null,
    Object? createdDate = null,
    Object? updatedDate = null,
  }) {
    return _then(
      _$CreditCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        bankName: null == bankName
            ? _value.bankName
            : bankName // ignore: cast_nullable_to_non_nullable
                  as String,
        cardName: null == cardName
            ? _value.cardName
            : cardName // ignore: cast_nullable_to_non_nullable
                  as String,
        cardType: null == cardType
            ? _value.cardType
            : cardType // ignore: cast_nullable_to_non_nullable
                  as String,
        last4Digits: null == last4Digits
            ? _value.last4Digits
            : last4Digits // ignore: cast_nullable_to_non_nullable
                  as String,
        cardColor: null == cardColor
            ? _value.cardColor
            : cardColor // ignore: cast_nullable_to_non_nullable
                  as String,
        creditLimit: null == creditLimit
            ? _value.creditLimit
            : creditLimit // ignore: cast_nullable_to_non_nullable
                  as double,
        statementDate: null == statementDate
            ? _value.statementDate
            : statementDate // ignore: cast_nullable_to_non_nullable
                  as int,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as int,
        reminderDaysBefore: null == reminderDaysBefore
            ? _value.reminderDaysBefore
            : reminderDaysBefore // ignore: cast_nullable_to_non_nullable
                  as int,
        outstandingAmount: null == outstandingAmount
            ? _value.outstandingAmount
            : outstandingAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        minimumDue: null == minimumDue
            ? _value.minimumDue
            : minimumDue // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        createdDate: null == createdDate
            ? _value.createdDate
            : createdDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedDate: null == updatedDate
            ? _value.updatedDate
            : updatedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreditCardImpl implements _CreditCard {
  const _$CreditCardImpl({
    required this.id,
    required this.bankName,
    required this.cardName,
    required this.cardType,
    required this.last4Digits,
    required this.cardColor,
    required this.creditLimit,
    required this.statementDate,
    required this.dueDate,
    required this.reminderDaysBefore,
    required this.outstandingAmount,
    required this.minimumDue,
    required this.paymentStatus,
    required this.notes,
    required this.createdDate,
    required this.updatedDate,
  });

  factory _$CreditCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreditCardImplFromJson(json);

  @override
  final String id;
  @override
  final String bankName;
  @override
  final String cardName;
  @override
  final String cardType;
  // e.g. Visa, Mastercard, Amex, etc.
  @override
  final String last4Digits;
  @override
  final String cardColor;
  // e.g. Carbon, Sapphire, etc.
  @override
  final double creditLimit;
  @override
  final int statementDate;
  // 1-31
  @override
  final int dueDate;
  // 1-31
  @override
  final int reminderDaysBefore;
  @override
  final double outstandingAmount;
  @override
  final double minimumDue;
  @override
  final String paymentStatus;
  // 'Paid', 'Unpaid', 'Overdue', 'Archived'
  @override
  final String notes;
  @override
  final DateTime createdDate;
  @override
  final DateTime updatedDate;

  @override
  String toString() {
    return 'CreditCard(id: $id, bankName: $bankName, cardName: $cardName, cardType: $cardType, last4Digits: $last4Digits, cardColor: $cardColor, creditLimit: $creditLimit, statementDate: $statementDate, dueDate: $dueDate, reminderDaysBefore: $reminderDaysBefore, outstandingAmount: $outstandingAmount, minimumDue: $minimumDue, paymentStatus: $paymentStatus, notes: $notes, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreditCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.cardName, cardName) ||
                other.cardName == cardName) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.last4Digits, last4Digits) ||
                other.last4Digits == last4Digits) &&
            (identical(other.cardColor, cardColor) ||
                other.cardColor == cardColor) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit) &&
            (identical(other.statementDate, statementDate) ||
                other.statementDate == statementDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.reminderDaysBefore, reminderDaysBefore) ||
                other.reminderDaysBefore == reminderDaysBefore) &&
            (identical(other.outstandingAmount, outstandingAmount) ||
                other.outstandingAmount == outstandingAmount) &&
            (identical(other.minimumDue, minimumDue) ||
                other.minimumDue == minimumDue) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.updatedDate, updatedDate) ||
                other.updatedDate == updatedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    bankName,
    cardName,
    cardType,
    last4Digits,
    cardColor,
    creditLimit,
    statementDate,
    dueDate,
    reminderDaysBefore,
    outstandingAmount,
    minimumDue,
    paymentStatus,
    notes,
    createdDate,
    updatedDate,
  );

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreditCardImplCopyWith<_$CreditCardImpl> get copyWith =>
      __$$CreditCardImplCopyWithImpl<_$CreditCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreditCardImplToJson(this);
  }
}

abstract class _CreditCard implements CreditCard {
  const factory _CreditCard({
    required final String id,
    required final String bankName,
    required final String cardName,
    required final String cardType,
    required final String last4Digits,
    required final String cardColor,
    required final double creditLimit,
    required final int statementDate,
    required final int dueDate,
    required final int reminderDaysBefore,
    required final double outstandingAmount,
    required final double minimumDue,
    required final String paymentStatus,
    required final String notes,
    required final DateTime createdDate,
    required final DateTime updatedDate,
  }) = _$CreditCardImpl;

  factory _CreditCard.fromJson(Map<String, dynamic> json) =
      _$CreditCardImpl.fromJson;

  @override
  String get id;
  @override
  String get bankName;
  @override
  String get cardName;
  @override
  String get cardType; // e.g. Visa, Mastercard, Amex, etc.
  @override
  String get last4Digits;
  @override
  String get cardColor; // e.g. Carbon, Sapphire, etc.
  @override
  double get creditLimit;
  @override
  int get statementDate; // 1-31
  @override
  int get dueDate; // 1-31
  @override
  int get reminderDaysBefore;
  @override
  double get outstandingAmount;
  @override
  double get minimumDue;
  @override
  String get paymentStatus; // 'Paid', 'Unpaid', 'Overdue', 'Archived'
  @override
  String get notes;
  @override
  DateTime get createdDate;
  @override
  DateTime get updatedDate;

  /// Create a copy of CreditCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreditCardImplCopyWith<_$CreditCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

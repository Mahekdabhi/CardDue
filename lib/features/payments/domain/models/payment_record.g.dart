// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentRecordImpl _$$PaymentRecordImplFromJson(Map<String, dynamic> json) =>
    _$PaymentRecordImpl(
      id: json['id'] as String,
      cardId: json['cardId'] as String,
      paidAmount: (json['paidAmount'] as num).toDouble(),
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      notes: json['notes'] as String,
    );

Map<String, dynamic> _$$PaymentRecordImplToJson(_$PaymentRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cardId': instance.cardId,
      'paidAmount': instance.paidAmount,
      'paymentDate': instance.paymentDate.toIso8601String(),
      'notes': instance.notes,
    };

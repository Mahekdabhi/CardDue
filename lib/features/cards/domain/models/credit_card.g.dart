// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreditCardImpl _$$CreditCardImplFromJson(Map<String, dynamic> json) =>
    _$CreditCardImpl(
      id: json['id'] as String,
      bankName: json['bankName'] as String,
      cardName: json['cardName'] as String,
      cardType: json['cardType'] as String,
      last4Digits: json['last4Digits'] as String,
      cardColor: json['cardColor'] as String,
      creditLimit: (json['creditLimit'] as num).toDouble(),
      statementDate: (json['statementDate'] as num).toInt(),
      dueDate: (json['dueDate'] as num).toInt(),
      reminderDaysBefore: (json['reminderDaysBefore'] as num).toInt(),
      outstandingAmount: (json['outstandingAmount'] as num).toDouble(),
      minimumDue: (json['minimumDue'] as num).toDouble(),
      paymentStatus: json['paymentStatus'] as String,
      notes: json['notes'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      updatedDate: DateTime.parse(json['updatedDate'] as String),
    );

Map<String, dynamic> _$$CreditCardImplToJson(_$CreditCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bankName': instance.bankName,
      'cardName': instance.cardName,
      'cardType': instance.cardType,
      'last4Digits': instance.last4Digits,
      'cardColor': instance.cardColor,
      'creditLimit': instance.creditLimit,
      'statementDate': instance.statementDate,
      'dueDate': instance.dueDate,
      'reminderDaysBefore': instance.reminderDaysBefore,
      'outstandingAmount': instance.outstandingAmount,
      'minimumDue': instance.minimumDue,
      'paymentStatus': instance.paymentStatus,
      'notes': instance.notes,
      'createdDate': instance.createdDate.toIso8601String(),
      'updatedDate': instance.updatedDate.toIso8601String(),
    };

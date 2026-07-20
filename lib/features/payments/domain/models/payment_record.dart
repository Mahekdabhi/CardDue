import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_record.freezed.dart';
part 'payment_record.g.dart';

@freezed
class PaymentRecord with _$PaymentRecord {
  const factory PaymentRecord({
    required String id,
    required String cardId,
    required double paidAmount,
    required DateTime paymentDate,
    required String notes,
  }) = _PaymentRecord;

  factory PaymentRecord.fromJson(Map<String, dynamic> json) => _$PaymentRecordFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card.freezed.dart';
part 'credit_card.g.dart';

@freezed
class CreditCard with _$CreditCard {
  const factory CreditCard({
    required String id,
    required String bankName,
    required String cardName,
    required String cardType, // e.g. Visa, Mastercard, Amex, etc.
    required String last4Digits,
    required String cardColor, // e.g. Carbon, Sapphire, etc.
    required double creditLimit,
    required int statementDate, // 1-31
    required int dueDate, // 1-31
    required int reminderDaysBefore,
    required double outstandingAmount,
    required double minimumDue,
    required String paymentStatus, // 'Paid', 'Unpaid', 'Overdue', 'Archived'
    required String notes,
    @Default('09:00') String reminderTime,
    required DateTime createdDate,
    required DateTime updatedDate,
  }) = _CreditCard;

  factory CreditCard.fromJson(Map<String, dynamic> json) => _$CreditCardFromJson(json);
}

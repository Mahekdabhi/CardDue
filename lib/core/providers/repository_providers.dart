import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/cards/data/repository/card_repository_impl.dart';
import '../../features/cards/domain/repository/card_repository.dart';
import '../../features/payments/data/repository/payment_repository_impl.dart';
import '../../features/payments/domain/repository/payment_repository.dart';

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return CardRepositoryImpl();
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl();
});

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../domain/models/payment_record.dart';
import '../../domain/repository/payment_repository.dart';

class PaymentState {
  final List<PaymentRecord> payments;
  final bool isLoading;

  PaymentState({
    required this.payments,
    this.isLoading = false,
  });

  PaymentState copyWith({
    List<PaymentRecord>? payments,
    bool? isLoading,
  }) {
    return PaymentState(
      payments: payments ?? this.payments,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepository _paymentRepository;
  StreamSubscription<List<PaymentRecord>>? _subscription;

  PaymentNotifier(this._paymentRepository) : super(PaymentState(payments: [])) {
    _init();
  }

  void _init() {
    state = state.copyWith(isLoading: true);
    _subscription = _paymentRepository.watchPayments().listen((logs) {
      state = state.copyWith(payments: logs, isLoading: false);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> logPayment({
    required String cardId,
    required double amount,
    required DateTime date,
    required String notes,
  }) async {
    final record = PaymentRecord(
      id: const Uuid().v4(),
      cardId: cardId,
      paidAmount: amount,
      paymentDate: date,
      notes: notes,
    );
    await _paymentRepository.savePayment(record);
  }

  Future<void> deletePayment(String id) async {
    await _paymentRepository.deletePayment(id);
  }

  Future<void> clearAll() async {
    await _paymentRepository.clearAll();
  }

  Future<void> restoreBackup(List<PaymentRecord> backupPayments) async {
    await _paymentRepository.clearAll();
    for (final record in backupPayments) {
      await _paymentRepository.savePayment(record);
    }
  }

  List<PaymentRecord> getPaymentsForCard(String cardId) {
    final result = state.payments.where((p) => p.cardId == cardId).toList();
    result.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
    return result;
  }
}

final paymentViewModelProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return PaymentNotifier(repository);
});

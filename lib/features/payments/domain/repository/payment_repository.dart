import '../models/payment_record.dart';

abstract class PaymentRepository {
  Stream<List<PaymentRecord>> watchPayments();
  Future<List<PaymentRecord>> getPayments();
  Future<void> savePayment(PaymentRecord record);
  Future<void> deletePayment(String id);
  Future<void> clearAll();
}

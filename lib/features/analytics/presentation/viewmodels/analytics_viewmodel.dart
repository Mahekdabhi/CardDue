import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cards/presentation/viewmodels/card_viewmodel.dart';
import '../../../payments/presentation/viewmodels/payment_viewmodel.dart';

class AnalyticsData {
  final double totalOutstanding;
  final double totalCreditLimit;
  final double creditUtilization; // 0.0 to 100.0
  final double monthlyPaidAmount; // amount paid in current month
  final double monthlyOutstandingAmount; // total outstanding due this month
  final Map<String, double> outstandingByCard; // Card Label -> Outstanding Amount
  final Map<String, double> utilizationByCard; // Card Label -> Utilization %
  final Map<String, double> monthlyPaymentTrend; // Month Name -> Paid Amount (last 6 months)

  AnalyticsData({
    required this.totalOutstanding,
    required this.totalCreditLimit,
    required this.creditUtilization,
    required this.monthlyPaidAmount,
    required this.monthlyOutstandingAmount,
    required this.outstandingByCard,
    required this.utilizationByCard,
    required this.monthlyPaymentTrend,
  });
}

final analyticsProvider = Provider<AnalyticsData>((ref) {
  final cardState = ref.watch(cardViewModelProvider);
  final paymentState = ref.watch(paymentViewModelProvider);

  final cards = cardState.cards.where((c) => c.paymentStatus != 'Archived').toList();
  final payments = paymentState.payments;

  // 1. Total Outstanding & Limit calculation
  double totalOutstanding = 0;
  double totalCreditLimit = 0;
  final Map<String, double> outstandingByCard = {};
  final Map<String, double> utilizationByCard = {};

  for (final card in cards) {
    totalOutstanding += card.outstandingAmount;
    totalCreditLimit += card.creditLimit;
    
    final cardLabel = '${card.bankName} (${card.last4Digits})';
    outstandingByCard[cardLabel] = card.outstandingAmount;
    utilizationByCard[cardLabel] = card.creditLimit > 0 
        ? (card.outstandingAmount / card.creditLimit) * 100 
        : 0.0;
  }

  final creditUtilization = totalCreditLimit > 0 
      ? (totalOutstanding / totalCreditLimit) * 100 
      : 0.0;

  // 2. Monthly Paid Amount calculation (current calendar month)
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

  double monthlyPaidAmount = 0;
  for (final payment in payments) {
    if (payment.paymentDate.isAfter(startOfMonth) && payment.paymentDate.isBefore(endOfMonth)) {
      monthlyPaidAmount += payment.paidAmount;
    }
  }

  // 3. Imminent outstanding due this month
  double monthlyOutstandingAmount = 0;
  for (final card in cards) {
    final nextDue = CardNotifier.resolveNextDueDate(card.statementDate, card.dueDate);
    if (nextDue.month == now.month && nextDue.year == now.year) {
      monthlyOutstandingAmount += card.outstandingAmount;
    }
  }

  // 4. Monthly Payment Trend calculation (last 6 months rolling)
  final Map<String, double> monthlyPaymentTrend = {};
  final monthsList = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  
  for (int i = 5; i >= 0; i--) {
    // Generate dates representing trailing months
    final targetMonthDate = DateTime(now.year, now.month - i, 1);
    final monthStart = DateTime(targetMonthDate.year, targetMonthDate.month, 1);
    final monthEnd = DateTime(targetMonthDate.year, targetMonthDate.month + 1, 0, 23, 59, 59);
    final label = '${monthsList[monthStart.month - 1]} ${monthStart.year % 100}';
    
    double amount = 0;
    for (final payment in payments) {
      if (payment.paymentDate.isAfter(monthStart) && payment.paymentDate.isBefore(monthEnd)) {
        amount += payment.paidAmount;
      }
    }
    monthlyPaymentTrend[label] = amount;
  }

  return AnalyticsData(
    totalOutstanding: totalOutstanding,
    totalCreditLimit: totalCreditLimit,
    creditUtilization: creditUtilization,
    monthlyPaidAmount: monthlyPaidAmount,
    monthlyOutstandingAmount: monthlyOutstandingAmount,
    outstandingByCard: outstandingByCard,
    utilizationByCard: utilizationByCard,
    monthlyPaymentTrend: monthlyPaymentTrend,
  );
});

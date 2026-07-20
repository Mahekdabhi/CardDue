import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/services/ics_service.dart';
import '../../../../widgets/glass_container.dart';
import '../../../../widgets/input_field.dart';
import '../../../../widgets/top_toast.dart';
import '../../../analytics/presentation/viewmodels/analytics_viewmodel.dart';
import '../../../cards/domain/models/credit_card.dart';
import '../../../cards/presentation/viewmodels/card_viewmodel.dart';
import '../../../cards/presentation/widgets/credit_card_widget.dart';
import '../../../payments/presentation/viewmodels/payment_viewmodel.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardState = ref.watch(cardViewModelProvider);
    final cardNotifier = ref.read(cardViewModelProvider.notifier);
    final analytics = ref.watch(analyticsProvider);

    final filteredCards = cardNotifier.getFilteredCards();

    // Custom slate colors for styling
    final textSecondaryColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B); // Slate 400 / 500
    final chipTextColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);       // Slate 300 / 700
    final dividerColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);        // Slate 800 / 200

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. App Header Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CardDue',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.8,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          'Your offline credit card manager',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.bar_chart_rounded, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155), size: 28),
                          onPressed: () => context.push('/analytics'),
                          tooltip: 'Analytics',
                        ),
                        IconButton(
                          icon: Icon(Icons.settings_rounded, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155), size: 26),
                          onPressed: () => context.push('/settings'),
                          tooltip: 'Settings',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 2. Metrics Card (Total Outstanding, Limits, Utilization %)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassContainer(
                  padding: const EdgeInsets.all(24),
                  borderRadius: 28,
                  blur: 10,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL OUTSTANDING',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                  color: textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '₹${analytics.totalOutstanding.toStringAsFixed(2)}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w800,
                                  color: analytics.totalOutstanding > 0 && !isDark 
                                      ? AppColors.accent 
                                      : (isDark ? Colors.white : Colors.black),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: analytics.creditUtilization > 30 
                                  ? AppColors.overdue.withValues(alpha: 0.15) 
                                  : AppColors.paid.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${analytics.creditUtilization.toStringAsFixed(1)}% Utilized',
                              style: TextStyle(
                                color: analytics.creditUtilization > 30 
                                    ? AppColors.overdue 
                                    : AppColors.paid,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: analytics.totalCreditLimit > 0 
                              ? (analytics.totalOutstanding / analytics.totalCreditLimit) 
                              : 0.0,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0), // Slate 800 / 200
                          valueColor: AlwaysStoppedAnimation<Color>(
                            analytics.creditUtilization > 30 
                                ? AppColors.overdue 
                                : AppColors.accent,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Limit: ₹${analytics.totalCreditLimit.toStringAsFixed(0)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: textSecondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Due This Month: ₹${analytics.monthlyOutstandingAmount.toStringAsFixed(0)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: textSecondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Search and Sort Tools
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: cardNotifier.setSearchQuery,
                        decoration: InputDecoration(
                          hintText: 'Search bank, card name...',
                          prefixIcon: Icon(Icons.search_rounded, color: textSecondaryColor),
                          filled: true,
                          fillColor: isDark ? AppColors.darkCard : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.accent),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.sort_rounded, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                      onSelected: cardNotifier.setSortBy,
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'due_date', child: Text('Sort by Due Date')),
                        const PopupMenuItem(value: 'outstanding', child: Text('Sort by Outstanding')),
                        const PopupMenuItem(value: 'bank_name', child: Text('Sort by Bank Name')),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 4. Horizontal Filters
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilterChip(ref, 'All Cards', 'all', chipTextColor),
                    _buildFilterChip(ref, 'Upcoming', 'upcoming', chipTextColor),
                    _buildFilterChip(ref, 'Overdue', 'overdue', chipTextColor),
                    _buildFilterChip(ref, 'Paid', 'paid', chipTextColor),
                    _buildFilterChip(ref, 'This Month', 'this_month', chipTextColor),
                  ],
                ),
              ),
            ),

            // 5. Cards List
            filteredCards.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card_off_rounded, size: 80, color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)), // Slate 700 / 300
                          const SizedBox(height: 16),
                          Text(
                            'No Cards Found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cardState.cards.isEmpty
                                ? "Tap '+' below to add your first credit card offline."
                                : "Try clearing search or filters to see all cards.",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final card = filteredCards[index];
                        return CreditCardWidget(
                          card: card,
                          onEdit: () => context.push('/edit-card/${card.id}'),
                          onActionMenu: () => _showActionMenu(context, ref, card, dividerColor),
                        );
                      },
                      childCount: filteredCards.length,
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => context.push('/add-card'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Card', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildFilterChip(WidgetRef ref, String label, String value, Color defaultTextColor) {
    final activeFilter = ref.watch(cardViewModelProvider).filterBy;
    final notifier = ref.read(cardViewModelProvider.notifier);
    final isSelected = activeFilter == value;

    final isDark = Theme.of(ref.context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) notifier.setFilterBy(value);
        },
        selectedColor: AppColors.accent,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : defaultTextColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected 
                ? Colors.transparent 
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _showActionMenu(BuildContext context, WidgetRef ref, CreditCard card, Color dividerColor) {
    final cardNotifier = ref.read(cardViewModelProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondaryColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: isDark ? AppColors.darkBg : Colors.white,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.bankName,
                            style: const TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${card.cardName} •••• ${card.last4Digits}',
                            style: TextStyle(color: textSecondaryColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: dividerColor),
              if (card.outstandingAmount > 0)
                ListTile(
                  leading: const Icon(Icons.check_circle_outline_rounded, color: AppColors.paid),
                  title: const Text('Mark as Paid', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.paid)),
                  onTap: () {
                    Navigator.pop(context);
                    _showPaymentDialog(context, ref, card);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.calendar_today_rounded, color: AppColors.accent),
                title: const Text('Download Apple Calendar File (.ics)'),
                onTap: () async {
                  Navigator.pop(context);
                  final nextDue = CardNotifier.resolveNextDueDate(card.statementDate, card.dueDate);
                  await IcsService.generateAndDownloadIcs(card, nextDue);
                  
                  if (!context.mounted) return;
                  TopToast.show(
                    context,
                    'Calendar file download triggered successfully!',
                    backgroundColor: AppColors.paid,
                    icon: Icons.check_circle_outline_rounded,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_all_rounded, color: AppColors.warning),
                title: const Text('Duplicate Card'),
                onTap: () async {
                  Navigator.pop(context);
                  await cardNotifier.duplicateCard(card);
                },
              ),
              if (card.paymentStatus == 'Archived')
                ListTile(
                  leading: const Icon(Icons.unarchive_rounded, color: AppColors.info),
                  title: const Text('Restore from Archive'),
                  onTap: () async {
                    Navigator.pop(context);
                    await cardNotifier.unarchiveCard(card);
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.archive_outlined, color: Colors.blueGrey),
                  title: const Text('Archive Card'),
                  onTap: () async {
                    Navigator.pop(context);
                    await cardNotifier.archiveCard(card);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete_forever_rounded, color: AppColors.overdue),
                title: const Text('Delete Card', style: TextStyle(color: AppColors.overdue)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmDialog(context, cardNotifier, card);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, CardNotifier notifier, CreditCard card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Card', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to permanently delete your ${card.bankName} card? All logged payment records will remain in payment history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await notifier.deleteCard(card.id);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.overdue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, WidgetRef ref, CreditCard card) {
    final amountController = TextEditingController(text: card.outstandingAmount.toStringAsFixed(2));
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Log Payment: ${card.bankName}',
            style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PremiumInputField(
                  labelText: 'Paid Amount (₹)',
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter paid amount';
                    final parsed = double.tryParse(val);
                    if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PremiumInputField(
                  labelText: 'Notes',
                  hintText: 'e.g. Paid via Auto Debit / NetBanking',
                  controller: notesController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  final amount = double.parse(amountController.text);
                  final notes = notesController.text;

                  // 1. Log payment transaction
                  await ref.read(paymentViewModelProvider.notifier).logPayment(
                    cardId: card.id,
                    amount: amount,
                    date: DateTime.now(),
                    notes: notes,
                  );

                  // 2. Deduct outstanding from card
                  final remainingOutstanding = card.outstandingAmount - amount;
                  final newOutstanding = remainingOutstanding < 0 ? 0.0 : remainingOutstanding;
                  final newMinimum = card.minimumDue - amount;
                  final newMinimumDue = newMinimum < 0 ? 0.0 : newMinimum;

                  await ref.read(cardViewModelProvider.notifier).updateCard(
                    card.copyWith(
                      outstandingAmount: newOutstanding,
                      minimumDue: newMinimumDue,
                    ),
                  );

                  if (!context.mounted) return;
                  Navigator.pop(context);
                  TopToast.show(
                    context,
                    'Logged payment of ₹${amount.toStringAsFixed(2)} successfully!',
                    backgroundColor: AppColors.paid,
                    icon: Icons.check_circle_outline_rounded,
                  );
                }
              },
              child: const Text('Log Payment', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

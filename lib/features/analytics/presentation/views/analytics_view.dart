import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../widgets/glass_container.dart';
import '../viewmodels/analytics_viewmodel.dart';

class AnalyticsView extends ConsumerWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final analytics = ref.watch(analyticsProvider);

    // Compute max value for scaling the custom bar chart
    final trendValues = analytics.monthlyPaymentTrend.values.toList();
    final maxTrendValue = trendValues.isNotEmpty 
        ? trendValues.reduce((curr, next) => curr > next ? curr : next)
        : 0.0;

    // Define premium slate colors directly
    final slate400 = const Color(0xFF94A3B8);
    final slate500 = const Color(0xFF64748B);
    final slate600 = const Color(0xFF475569);
    final progressBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0); // Slate 800 / 200

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Analytics', style: TextStyle(fontFamily: 'Outfit')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Credit Utilization Gauge Card (Static top card: optimized to blur 10)
              GlassContainer(
                padding: const EdgeInsets.all(24),
                borderRadius: 24,
                blur: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CREDIT UTILIZATION',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: slate500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${analytics.creditUtilization.toStringAsFixed(1)}%',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w800,
                              color: analytics.creditUtilization > 30 
                                  ? AppColors.overdue 
                                  : AppColors.paid,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            analytics.creditUtilization > 30
                                ? 'Warning: Utilization exceeds 30%. Paying this down will improve your credit score.'
                                : 'Excellent: Your credit utilization ratio is healthy (below 30%).',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? slate400 : slate600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: analytics.creditUtilization / 100,
                              strokeWidth: 12,
                              backgroundColor: progressBg,
                              color: analytics.creditUtilization > 30 
                                  ? AppColors.overdue 
                                  : AppColors.paid,
                            ),
                            Text(
                              '${analytics.creditUtilization.toStringAsFixed(0)}%',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. Custom Trailing 6-Month Payment Chart (Static top card: optimized to blur 10)
              Text(
                'Payment History Trend',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              GlassContainer(
                padding: const EdgeInsets.all(24),
                borderRadius: 24,
                blur: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Paid this month',
                          style: TextStyle(color: slate500, fontSize: 13),
                        ),
                        Text(
                          '₹${analytics.monthlyPaidAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Drawing the bars dynamically
                    SizedBox(
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: analytics.monthlyPaymentTrend.entries.map((entry) {
                          final label = entry.key;
                          final amount = entry.value;

                          // Compute height ratio
                          final ratio = maxTrendValue > 0 ? (amount / maxTrendValue) : 0.0;
                          final barHeight = ratio * 100 + 8.0; // min height of 8

                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Tooltip(
                                  message: '₹${amount.toStringAsFixed(2)}',
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [AppColors.accent, Color(0xFF818CF8)],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? slate400 : slate600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Card breakdown list (Scrollable list items: optimized to blur 0)
              Text(
                'Theme and Utilization Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: analytics.outstandingByCard.length,
                itemBuilder: (context, index) {
                  final key = analytics.outstandingByCard.keys.elementAt(index);
                  final outstanding = analytics.outstandingByCard[key] ?? 0.0;
                  final utilization = analytics.utilizationByCard[key] ?? 0.0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      borderRadius: 16,
                      blur: 0, // Bypasses BackdropFilter for maximum scroll performance
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  key,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Outstanding: ₹${outstanding.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: slate500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${utilization.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: utilization > 30 ? AppColors.overdue : AppColors.paid,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'utilization',
                                style: TextStyle(
                                  color: isDark ? slate500 : slate400,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

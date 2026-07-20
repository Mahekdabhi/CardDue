import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/utils/file_helper.dart';
import '../../../../widgets/glass_container.dart';
import '../../../../widgets/top_toast.dart';
import '../../../cards/domain/models/credit_card.dart';
import '../../../cards/presentation/viewmodels/card_viewmodel.dart';
import '../../../payments/domain/models/payment_record.dart';
import '../../../payments/presentation/viewmodels/payment_viewmodel.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    final cardState = ref.watch(cardViewModelProvider);
    final paymentState = ref.watch(paymentViewModelProvider);

    final textSecondaryColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569); // Slate 400 / 600
    final labelColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);         // Slate 300 / 700

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontFamily: 'Outfit')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. APPEARANCE GROUP
              _buildSectionTitle('APPEARANCE'),
              const SizedBox(height: 10),
              GlassContainer(
                padding: const EdgeInsets.all(20),
                borderRadius: 20,
                blur: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Theme Mode',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildThemeChip(ref, themeNotifier, 'System', ThemeMode.system, themeMode, labelColor),
                        _buildThemeChip(ref, themeNotifier, 'Light', ThemeMode.light, themeMode, labelColor),
                        _buildThemeChip(ref, themeNotifier, 'Dark', ThemeMode.dark, themeMode, labelColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 2. DATA MANAGEMENT GROUP
              _buildSectionTitle('DATA MANAGEMENT'),
              const SizedBox(height: 10),
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                borderRadius: 20,
                blur: 0,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.file_download_rounded, color: AppColors.accent),
                      title: const Text('Export Data (JSON)'),
                      subtitle: const Text('Download all credit cards and payment logs.'),
                      onTap: () => _exportBackup(context, cardState.cards, paymentState.payments),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.file_upload_rounded, color: AppColors.paid),
                      title: const Text('Import Data (JSON)'),
                      subtitle: const Text('Restore cards and payments from a backup file.'),
                      onTap: () => _importBackup(context, ref),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.delete_sweep_rounded, color: AppColors.overdue),
                      title: const Text('Reset Database', style: TextStyle(color: AppColors.overdue)),
                      subtitle: const Text('Clear all cards and payments permanently.'),
                      onTap: () => _showResetDialog(context, ref),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 3. ABOUT APPLICATION GROUP
              _buildSectionTitle('ABOUT'),
              const SizedBox(height: 10),
              GlassContainer(
                padding: const EdgeInsets.all(24),
                borderRadius: 20,
                blur: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CardDue v1.0.0',
                      style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'CardDue is a 100% free personal finance credit card bill tracking application. It stores your card credentials, statements, outstanding balances, and logs payment history directly inside your browser\'s local database (IndexedDB).',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textSecondaryColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.offline_pin_rounded, color: AppColors.paid, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Fully Offline Capable',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: Color(0xFF64748B), // Slate 500
        ),
      ),
    );
  }

  Widget _buildThemeChip(
    WidgetRef ref,
    ThemeModeNotifier notifier,
    String label,
    ThemeMode mode,
    ThemeMode activeMode,
    Color defaultTextColor,
  ) {
    final isSelected = activeMode == mode;
    final isDark = Theme.of(ref.context).brightness == Brightness.dark;

    return ChoiceChip(
      label: Container(
        alignment: Alignment.center,
        width: 64,
        child: Text(label),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) notifier.setThemeMode(mode);
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
    );
  }

  // Backup Export
  void _exportBackup(BuildContext context, List<CreditCard> cards, List<PaymentRecord> payments) async {
    try {
      final backupMap = {
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'cards': cards.map((c) => c.toJson()).toList(),
        'payments': payments.map((p) => p.toJson()).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(backupMap);
      await FileHelper.downloadFile(
        content: jsonString,
        fileName: 'carddue_backup_${DateFormat('yyyyMMdd').format(DateTime.now())}.json',
        mimeType: 'application/json',
      );

      if (context.mounted) {
        TopToast.show(
          context,
          'Backup exported successfully! Check downloads.',
          backgroundColor: AppColors.paid,
          icon: Icons.check_circle_outline_rounded,
        );
      }
    } catch (e) {
      if (context.mounted) {
        TopToast.show(
          context,
          'Export failed: $e',
          backgroundColor: AppColors.overdue,
          icon: Icons.error_outline_rounded,
        );
      }
    }
  }

  // Backup Import
  void _importBackup(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true, // Crucial for Web compatibility
      );

      if (result != null && result.files.isNotEmpty) {
        final fileBytes = result.files.first.bytes;
        if (fileBytes == null) throw Exception('No bytes found in selected file.');

        final contentString = utf8.decode(fileBytes);
        final dynamic decoded = jsonDecode(contentString);

        if (decoded is! Map<String, dynamic> || !decoded.containsKey('cards') || !decoded.containsKey('payments')) {
          throw Exception('Invalid backup file structure.');
        }

        // Parse cards list
        final List<dynamic> cardsJson = decoded['cards'];
        final List<CreditCard> importedCards = cardsJson.map((e) => CreditCard.fromJson(e as Map<String, dynamic>)).toList();

        // Parse payments list
        final List<dynamic> paymentsJson = decoded['payments'];
        final List<PaymentRecord> importedPayments = paymentsJson.map((e) => PaymentRecord.fromJson(e as Map<String, dynamic>)).toList();

        // Perform restore database action
        await ref.read(cardViewModelProvider.notifier).restoreBackup(importedCards);
        await ref.read(paymentViewModelProvider.notifier).restoreBackup(importedPayments);

        if (context.mounted) {
          TopToast.show(
            context,
            'Backup restored successfully! Cards and logs recovered.',
            backgroundColor: AppColors.paid,
            icon: Icons.check_circle_outline_rounded,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        TopToast.show(
          context,
          'Import failed: Check file format. ($e)',
          backgroundColor: AppColors.overdue,
          icon: Icons.error_outline_rounded,
        );
      }
    }
  }

  // Reset Database
  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Database?', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete all credit cards and transaction histories permanently? This action is local, offline, and cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(cardViewModelProvider.notifier).resetDatabase();
              await ref.read(paymentViewModelProvider.notifier).clearAll();
              
              if (context.mounted) {
                TopToast.show(
                  context,
                  'App database cleared successfully.',
                  backgroundColor: AppColors.warning,
                  icon: Icons.delete_sweep_rounded,
                );
              }
            },
            child: const Text('Reset All', style: TextStyle(color: AppColors.overdue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../widgets/input_field.dart';
import '../../../../widgets/premium_button.dart';
import '../../../../widgets/top_toast.dart';
import '../../domain/models/credit_card.dart';
import '../viewmodels/card_viewmodel.dart';
import '../widgets/credit_card_widget.dart';

class AddEditCardView extends ConsumerStatefulWidget {
  final String? cardId;

  const AddEditCardView({super.key, this.cardId});

  @override
  ConsumerState<AddEditCardView> createState() => _AddEditCardViewState();
}

class _AddEditCardViewState extends ConsumerState<AddEditCardView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _bankNameController;
  late TextEditingController _cardNameController;
  late TextEditingController _digitsController;
  late TextEditingController _limitController;
  late TextEditingController _outstandingController;
  late TextEditingController _minDueController;
  late TextEditingController _notesController;

  String _selectedType = AppStrings.typeVisa;
  String _selectedColor = AppStrings.colorSapphire;
  int _selectedStatementDate = 1;
  int _selectedDueDate = 15;
  int _selectedReminderDays = 1;

  bool _isEditing = false;
  CreditCard? _originalCard;

  @override
  void initState() {
    super.initState();
    _bankNameController = TextEditingController();
    _cardNameController = TextEditingController();
    _digitsController = TextEditingController();
    _limitController = TextEditingController();
    _outstandingController = TextEditingController();
    _minDueController = TextEditingController();
    _notesController = TextEditingController();

    // Attach listeners to trigger redraws for the real-time card visualizer
    _bankNameController.addListener(_onFormUpdate);
    _cardNameController.addListener(_onFormUpdate);
    _digitsController.addListener(_onFormUpdate);
    _outstandingController.addListener(_onFormUpdate);
    _limitController.addListener(_onFormUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.cardId != null) {
        _loadCardData();
      }
    });
  }

  void _onFormUpdate() {
    setState(() {});
  }

  void _loadCardData() {
    final cards = ref.read(cardViewModelProvider).cards;
    final card = cards.firstWhere((c) => c.id == widget.cardId);
    
    setState(() {
      _isEditing = true;
      _originalCard = card;

      _bankNameController.text = card.bankName;
      _cardNameController.text = card.cardName;
      _digitsController.text = card.last4Digits;
      _limitController.text = card.creditLimit.toStringAsFixed(0);
      _outstandingController.text = card.outstandingAmount.toStringAsFixed(2);
      _minDueController.text = card.minimumDue.toStringAsFixed(2);
      _notesController.text = card.notes;

      _selectedType = card.cardType;
      _selectedColor = card.cardColor;
      _selectedStatementDate = card.statementDate;
      _selectedDueDate = card.dueDate;
      _selectedReminderDays = card.reminderDaysBefore;
    });
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _cardNameController.dispose();
    _digitsController.dispose();
    _limitController.dispose();
    _outstandingController.dispose();
    _minDueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Generate a mock model from current form fields for the live preview widget
  CreditCard _buildPreviewCard() {
    return CreditCard(
      id: widget.cardId ?? 'preview',
      bankName: _bankNameController.text.isEmpty ? 'Bank Name' : _bankNameController.text,
      cardName: _cardNameController.text.isEmpty ? 'Card Holder' : _cardNameController.text,
      cardType: _selectedType,
      last4Digits: _digitsController.text.isEmpty ? '••••' : _digitsController.text,
      cardColor: _selectedColor,
      creditLimit: double.tryParse(_limitController.text) ?? 10000.0,
      statementDate: _selectedStatementDate,
      dueDate: _selectedDueDate,
      reminderDaysBefore: _selectedReminderDays,
      outstandingAmount: double.tryParse(_outstandingController.text) ?? 0.0,
      minimumDue: double.tryParse(_minDueController.text) ?? 0.0,
      paymentStatus: 'Unpaid',
      notes: _notesController.text,
      createdDate: _originalCard?.createdDate ?? DateTime.now(),
      updatedDate: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final previewCard = _buildPreviewCard();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Card' : 'Add Credit Card', style: const TextStyle(fontFamily: 'Outfit')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Live Card Visualizer
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: CreditCardWidget(card: previewCard),
            ),
            
            // 2. Scrollable Form Fields
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Type & Bank Name row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: PremiumInputField(
                              labelText: 'Bank Name',
                              hintText: 'e.g. Chase, Citi',
                              controller: _bankNameController,
                              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                                  child: Text(
                                    'Card Type',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedType,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                                    fillColor: isDark ? AppColors.darkCard : Colors.white,
                                  ),
                                  items: AppStrings.cardTypes.map((type) {
                                    return DropdownMenuItem(value: type, child: Text(type));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedType = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Card Nickname & Last 4 Digits
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: PremiumInputField(
                              labelText: 'Card Holder / Name',
                              hintText: 'e.g. Visa Signature',
                              controller: _cardNameController,
                              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: PremiumInputField(
                              labelText: 'Last 4 Digits',
                              hintText: '1234',
                              controller: _digitsController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Required';
                                if (v.length != 4) return 'Need 4';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Card Color selector (Premium Gradients)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 10),
                        child: Text(
                          'Select Card Theme',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 52,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: AppStrings.cardColors.length,
                          itemBuilder: (context, index) {
                            final colorName = AppStrings.cardColors[index];
                            final grad = AppColors.getCardGradient(colorName);
                            final isSel = _selectedColor == colorName;

                            return GestureDetector(
                              onTap: () => setState(() => _selectedColor = colorName),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: grad),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSel 
                                        ? (isDark ? Colors.white : Colors.black) 
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: isSel 
                                    ? const Icon(Icons.check, color: Colors.white, size: 20) 
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Card Limit & Outstanding & Min Due
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PremiumInputField(
                              labelText: 'Credit Limit (₹)',
                              hintText: '10000',
                              controller: _limitController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Required';
                                if (double.tryParse(v) == null) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PremiumInputField(
                              labelText: 'Outstanding (₹)',
                              hintText: '0.00',
                              controller: _outstandingController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Required';
                                if (double.tryParse(v) == null) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PremiumInputField(
                              labelText: 'Min Due (₹)',
                              hintText: '0.00',
                              controller: _minDueController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Required';
                                if (double.tryParse(v) == null) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Billing Dates & Reminders
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              title: 'Statement Day',
                              value: _selectedStatementDate,
                              items: List.generate(31, (i) => i + 1),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedStatementDate = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDropdown(
                              title: 'Payment Due Day',
                              value: _selectedDueDate,
                              items: List.generate(31, (i) => i + 1),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedDueDate = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDropdown(
                              title: 'Remind Before',
                              value: _selectedReminderDays,
                              items: const [0, 1, 2, 3, 5, 7],
                              labelFormatter: (val) => val == 0 ? 'Same Day' : '$val days',
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedReminderDays = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Notes Input field
                      PremiumInputField(
                        labelText: 'Notes',
                        hintText: 'Auto-debit instructions, bank contact, etc.',
                        controller: _notesController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),

                      // Confirm Action Button
                      PremiumButton(
                        onTap: _submitForm,
                        child: Text(
                          _isEditing ? 'Save Changes' : 'Create Card',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String title,
    required T value,
    required List<T> items,
    String Function(T)? labelFormatter,
    required ValueChanged<T?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
        ),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            fillColor: isDark ? AppColors.darkCard : Colors.white,
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                labelFormatter != null ? labelFormatter(item) : item.toString(),
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final cardNotifier = ref.read(cardViewModelProvider.notifier);

      final bank = _bankNameController.text;
      final name = _cardNameController.text;
      final type = _selectedType;
      final digits = _digitsController.text;
      final color = _selectedColor;
      final limit = double.parse(_limitController.text);
      final outstanding = double.parse(_outstandingController.text);
      final minDue = double.parse(_minDueController.text);
      final notes = _notesController.text;

      if (_isEditing && _originalCard != null) {
        final updated = _originalCard!.copyWith(
          bankName: bank,
          cardName: name,
          cardType: type,
          last4Digits: digits,
          cardColor: color,
          creditLimit: limit,
          statementDate: _selectedStatementDate,
          dueDate: _selectedDueDate,
          reminderDaysBefore: _selectedReminderDays,
          outstandingAmount: outstanding,
          minimumDue: minDue,
          notes: notes,
        );
        await cardNotifier.updateCard(updated);
        
        if (!mounted) return;
        TopToast.show(
          context,
          'Card updated successfully!',
          backgroundColor: AppColors.paid,
          icon: Icons.check_circle_outline_rounded,
        );
      } else {
        await cardNotifier.addCard(
          bankName: bank,
          cardName: name,
          cardType: type,
          last4Digits: digits,
          cardColor: color,
          creditLimit: limit,
          statementDate: _selectedStatementDate,
          dueDate: _selectedDueDate,
          reminderDaysBefore: _selectedReminderDays,
          outstandingAmount: outstanding,
          minimumDue: minDue,
          notes: notes,
        );
        
        if (!mounted) return;
        TopToast.show(
          context,
          'Credit card added successfully!',
          backgroundColor: AppColors.paid,
          icon: Icons.check_circle_outline_rounded,
        );
      }

      if (!mounted) return;
      context.go('/');
    }
  }
}

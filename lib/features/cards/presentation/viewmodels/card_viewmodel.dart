import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../domain/models/credit_card.dart';
import '../../domain/repository/card_repository.dart';

class CardState {
  final List<CreditCard> cards;
  final String searchQuery;
  final String sortBy; // 'due_date', 'bank_name', 'outstanding'
  final String filterBy; // 'all', 'upcoming', 'paid', 'overdue', 'this_month'
  final bool isLoading;

  CardState({
    required this.cards,
    this.searchQuery = '',
    this.sortBy = 'due_date',
    this.filterBy = 'all',
    this.isLoading = false,
  });

  CardState copyWith({
    List<CreditCard>? cards,
    String? searchQuery,
    String? sortBy,
    String? filterBy,
    bool? isLoading,
  }) {
    return CardState(
      cards: cards ?? this.cards,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      filterBy: filterBy ?? this.filterBy,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CardNotifier extends StateNotifier<CardState> {
  final CardRepository _cardRepository;
  StreamSubscription<List<CreditCard>>? _cardsSubscription;

  CardNotifier(this._cardRepository) : super(CardState(cards: [])) {
    _init();
  }

  void _init() {
    state = state.copyWith(isLoading: true);
    _cardsSubscription = _cardRepository.watchCards().listen((cardsList) {
      state = state.copyWith(cards: cardsList, isLoading: false);
    });
  }

  @override
  void dispose() {
    _cardsSubscription?.cancel();
    super.dispose();
  }

  // Setters for filters/sort/search
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSortBy(String criteria) {
    state = state.copyWith(sortBy: criteria);
  }

  void setFilterBy(String filter) {
    state = state.copyWith(filterBy: filter);
  }

  // CRUD Operations
  Future<void> addCard({
    required String bankName,
    required String cardName,
    required String cardType,
    required String last4Digits,
    required String cardColor,
    required double creditLimit,
    required int statementDate,
    required int dueDate,
    required int reminderDaysBefore,
    required double outstandingAmount,
    required double minimumDue,
    required String notes,
  }) async {
    final now = DateTime.now();
    final card = CreditCard(
      id: const Uuid().v4(),
      bankName: bankName,
      cardName: cardName,
      cardType: cardType,
      last4Digits: last4Digits,
      cardColor: cardColor,
      creditLimit: creditLimit,
      statementDate: statementDate,
      dueDate: dueDate,
      reminderDaysBefore: reminderDaysBefore,
      outstandingAmount: outstandingAmount,
      minimumDue: minimumDue,
      paymentStatus: outstandingAmount == 0 ? 'Paid' : 'Unpaid',
      notes: notes,
      createdDate: now,
      updatedDate: now,
    );
    await _cardRepository.saveCard(card);
  }

  Future<void> updateCard(CreditCard card) async {
    final updated = card.copyWith(
      updatedDate: DateTime.now(),
      paymentStatus: card.outstandingAmount == 0 ? 'Paid' : 'Unpaid',
    );
    await _cardRepository.saveCard(updated);
  }

  Future<void> deleteCard(String id) async {
    await _cardRepository.deleteCard(id);
  }

  Future<void> duplicateCard(CreditCard card) async {
    final duplicated = card.copyWith(
      id: const Uuid().v4(),
      cardName: '${card.cardName} (Copy)',
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );
    await _cardRepository.saveCard(duplicated);
  }

  Future<void> archiveCard(CreditCard card) async {
    final archived = card.copyWith(
      paymentStatus: 'Archived',
      updatedDate: DateTime.now(),
    );
    await _cardRepository.saveCard(archived);
  }

  Future<void> unarchiveCard(CreditCard card) async {
    final unarchived = card.copyWith(
      paymentStatus: card.outstandingAmount == 0 ? 'Paid' : 'Unpaid',
      updatedDate: DateTime.now(),
    );
    await _cardRepository.saveCard(unarchived);
  }

  Future<void> resetDatabase() async {
    await _cardRepository.clearAll();
  }

  Future<void> restoreBackup(List<CreditCard> backupCards) async {
    await _cardRepository.clearAll();
    for (final card in backupCards) {
      await _cardRepository.saveCard(card);
    }
  }

  // Next Due Date Math Utility
  static DateTime resolveNextDueDate(int statementDay, int dueDay) {
    final now = DateTime.now();
    
    // Normalize dates handling month bounds (like 31st on short months)
    DateTime getSafeDate(int year, int month, int day) {
      final temp = DateTime(year, month, 1);
      final daysInMonth = DateTime(temp.year, temp.month + 1, 0).day;
      final safeDay = day > daysInMonth ? daysInMonth : day;
      return DateTime(temp.year, temp.month, safeDay);
    }

    // Previous cycle candidate
    final pmDueDate = dueDay >= statementDay
        ? getSafeDate(now.year, now.month - 1, dueDay)
        : getSafeDate(now.year, now.month, dueDay);

    // Current cycle candidate
    final cmDueDate = dueDay >= statementDay
        ? getSafeDate(now.year, now.month, dueDay)
        : getSafeDate(now.year, now.month + 1, dueDay);

    // Today clean date (midnight)
    final today = DateTime(now.year, now.month, now.day);

    if (today.isBefore(pmDueDate) || today.isAtSameMomentAs(pmDueDate)) {
      return pmDueDate;
    } else if (today.isBefore(cmDueDate) || today.isAtSameMomentAs(cmDueDate)) {
      return cmDueDate;
    } else {
      // Next month cycle
      return dueDay >= statementDay
          ? getSafeDate(now.year, now.month + 1, dueDay)
          : getSafeDate(now.year, now.month + 2, dueDay);
    }
  }

  // Get dynamic card status string based on amount & date
  static String calculateCardStatus(CreditCard card) {
    if (card.paymentStatus == 'Archived') return 'Archived';
    if (card.outstandingAmount == 0) return 'Paid';
    
    final nextDue = resolveNextDueDate(card.statementDate, card.dueDate);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (nextDue.isBefore(today)) {
      return 'Overdue';
    }
    return 'Upcoming';
  }

  // Expose computed cards matching sorting & search & filters
  List<CreditCard> getFilteredCards() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 1. Apply Search and initial filter
    List<CreditCard> result = state.cards.where((card) {
      // Ignore archived cards by default unless explicitly in search or filters
      if (card.paymentStatus == 'Archived' && state.filterBy != 'archived') {
        return false;
      }

      // Search match
      final query = state.searchQuery.toLowerCase();
      final matchesSearch = card.bankName.toLowerCase().contains(query) ||
          card.cardName.toLowerCase().contains(query) ||
          card.last4Digits.contains(query);
      if (!matchesSearch) return false;

      // Filter match
      final resolvedStatus = calculateCardStatus(card);
      final nextDue = resolveNextDueDate(card.statementDate, card.dueDate);

      switch (state.filterBy) {
        case 'upcoming':
          return resolvedStatus == 'Upcoming' && card.outstandingAmount > 0;
        case 'overdue':
          return resolvedStatus == 'Overdue' && card.outstandingAmount > 0;
        case 'paid':
          return card.outstandingAmount == 0;
        case 'this_month':
          return nextDue.month == today.month && nextDue.year == today.year;
        default:
          return true;
      }
    }).toList();

    // 2. Apply Sorting
    result.sort((a, b) {
      switch (state.sortBy) {
        case 'bank_name':
          return a.bankName.toLowerCase().compareTo(b.bankName.toLowerCase());
        case 'outstanding':
          return b.outstandingAmount.compareTo(a.outstandingAmount);
        case 'due_date':
        default:
          final dueA = resolveNextDueDate(a.statementDate, a.dueDate);
          final dueB = resolveNextDueDate(b.statementDate, b.dueDate);
          return dueA.compareTo(dueB);
      }
    });

    return result;
  }
}

// Riverpod Provider definitions
final cardViewModelProvider = StateNotifierProvider<CardNotifier, CardState>((ref) {
  final repository = ref.watch(cardRepositoryProvider);
  return CardNotifier(repository);
});

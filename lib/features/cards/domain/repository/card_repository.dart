import '../models/credit_card.dart';

abstract class CardRepository {
  Stream<List<CreditCard>> watchCards();
  Future<List<CreditCard>> getCards();
  Future<void> saveCard(CreditCard card);
  Future<void> deleteCard(String id);
  Future<void> clearAll();
}

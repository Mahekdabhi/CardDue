import 'package:sembast/sembast.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/services/database_service.dart';
import '../../domain/models/credit_card.dart';
import '../../domain/repository/card_repository.dart';

class CardRepositoryImpl implements CardRepository {
  final DatabaseService _dbService = DatabaseService.instance;
  final _store = stringMapStoreFactory.store(AppStrings.cardStoreName);

  @override
  Stream<List<CreditCard>> watchCards() {
    return Stream.fromFuture(_dbService.database).asyncExpand((db) {
      return _store.query().onSnapshots(db).map((snapshots) {
        return snapshots.map((snap) => CreditCard.fromJson(snap.value)).toList();
      });
    });
  }

  @override
  Future<List<CreditCard>> getCards() async {
    final db = await _dbService.database;
    final snapshots = await _store.find(db);
    return snapshots.map((snap) => CreditCard.fromJson(snap.value)).toList();
  }

  @override
  Future<void> saveCard(CreditCard card) async {
    final db = await _dbService.database;
    await _store.record(card.id).put(db, card.toJson());
  }

  @override
  Future<void> deleteCard(String id) async {
    final db = await _dbService.database;
    await _store.record(id).delete(db);
  }

  @override
  Future<void> clearAll() async {
    final db = await _dbService.database;
    await _store.delete(db);
  }
}

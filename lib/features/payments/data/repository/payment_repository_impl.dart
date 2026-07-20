import 'package:sembast/sembast.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/services/database_service.dart';
import '../../domain/models/payment_record.dart';
import '../../domain/repository/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final DatabaseService _dbService = DatabaseService.instance;
  final _store = stringMapStoreFactory.store(AppStrings.paymentStoreName);

  @override
  Stream<List<PaymentRecord>> watchPayments() {
    return Stream.fromFuture(_dbService.database).asyncExpand((db) {
      return _store.query().onSnapshots(db).map((snapshots) {
        return snapshots.map((snap) => PaymentRecord.fromJson(snap.value)).toList();
      });
    });
  }

  @override
  Future<List<PaymentRecord>> getPayments() async {
    final db = await _dbService.database;
    final snapshots = await _store.find(db);
    return snapshots.map((snap) => PaymentRecord.fromJson(snap.value)).toList();
  }

  @override
  Future<void> savePayment(PaymentRecord record) async {
    final db = await _dbService.database;
    await _store.record(record.id).put(db, record.toJson());
  }

  @override
  Future<void> deletePayment(String id) async {
    final db = await _dbService.database;
    await _store.record(id).delete(db);
  }

  @override
  Future<void> clearAll() async {
    final db = await _dbService.database;
    await _store.delete(db);
  }
}

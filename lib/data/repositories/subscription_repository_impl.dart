import 'package:subsight/data/datasources/subscription_db.dart';
import 'package:subsight/features/subscription/bloc/subscription_repository.dart';
import 'package:subsight/features/subscription/models/subscription_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionDB _db = SubscriptionDB();

  @override
  Future<void> addToLocal(SubscriptionModel sub) async {
    await _db.insertSubscription(sub);
  }

  @override
  Future<List<SubscriptionModel>> getLocalSubscriptions() async {
    return await _db.getLocalSubscriptions();
  }

  @override
  Future<void> removeFromLocal(int id) async {
    await _db.removeSubscription(id);
  }

  @override
  Future<void> updateLocal(SubscriptionModel sub) async {
    await _db.updateSubscription(sub);
  }
}

import 'package:subsight/features/subscription/models/subscription_model.dart';

abstract class SubscriptionRepository {
  Future<List<SubscriptionModel>> fetchFromHtmlApi({int page});
  Future<void> addToLocal(SubscriptionModel sub);
  Future<void> removeFromLocal(int id);
  Future<void> updateLocal(SubscriptionModel sub);
  Future<List<SubscriptionModel>> getLocalSubscriptions();
}

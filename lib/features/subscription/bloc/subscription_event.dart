import 'package:equatable/equatable.dart';
import 'package:subsight/features/subscription/models/subscription_model.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class FetchSubscriptions extends SubscriptionEvent {
  final int page;
  const FetchSubscriptions({this.page = 1});

  @override
  List<Object?> get pops => [page];
}

class AddSubscription extends SubscriptionEvent {
  final SubscriptionModel subscription;

  const AddSubscription(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

class RemoveSubscription extends SubscriptionEvent {
  final int id;

  const RemoveSubscription(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateSubscription extends SubscriptionEvent {
  final SubscriptionModel updated;

  const UpdateSubscription(this.updated);

  @override
  List<Object?> get props => [updated];
}

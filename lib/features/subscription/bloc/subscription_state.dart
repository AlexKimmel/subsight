import 'package:equatable/equatable.dart';
import 'package:subsight/features/subscription/models/subscription_model.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionModel> subscriptions;
  final bool hasReachedEnd;

  const SubscriptionLoaded(this.subscriptions, {this.hasReachedEnd = false});

  SubscriptionLoaded copyWith({
    List<SubscriptionModel>? subscriptions,
    bool? hasReachedEnd,
  }) {
    return SubscriptionLoaded(
      subscriptions ?? this.subscriptions,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [subscriptions, hasReachedEnd];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}

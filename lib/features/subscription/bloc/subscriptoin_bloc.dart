import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsight/features/subscription/bloc/subscription_repository.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository repository;

  SubscriptionBloc(this.repository) : super(SubscriptionInitial()) {
    on<AddSubscription>(_onAddSubscription);
    on<RemoveSubscription>(_onRemoveSubscription);
    on<UpdateSubscription>(_onUpdateSubscription);
    on<LoadSubscriptions>(_onLoadSubscriptions);
  }

  Future<void> _onAddSubscription(
    AddSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    await repository.addToLocal(event.subscription);
    add(LoadSubscriptions());
  }

  Future<void> _onRemoveSubscription(
    RemoveSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    await repository.removeFromLocal(event.id);
    add(LoadSubscriptions());
  }

  Future<void> _onUpdateSubscription(
    UpdateSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    await repository.updateLocal(event.updated);
    add(LoadSubscriptions());
  }

  Future<void> _onLoadSubscriptions(
    LoadSubscriptions event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      final subs = await repository.getLocalSubscriptions();
      emit(SubscriptionLoaded(subs, hasReachedEnd: true));
    } catch (e) {
      emit(SubscriptionError("Failed to load subscriptions: $e"));
    }
  }
}

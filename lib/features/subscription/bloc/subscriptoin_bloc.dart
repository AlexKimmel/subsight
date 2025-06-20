import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsight/features/subscription/bloc/subscription_repository.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository repository;

  int _currentPage = 1;
  bool _hasReachedEnd = false;

  SubscriptionBloc(this.repository) : super(SubscriptionInitial()) {
    on<FetchSubscriptions>(_onFetchSubscriptions);
    on<AddSubscription>(_onAddSubscription);
    on<RemoveSubscription>(_onRemoveSubscription);
    on<UpdateSubscription>(_onUpdateSubscription);
  }

  Future<void> _onFetchSubscriptions(
    FetchSubscriptions event,
    Emitter<SubscriptionState> emit,
  ) async {
    if (_hasReachedEnd && event.page != 1) return;

    try {
      if (event.page == 1) emit(SubscriptionLoading());

      final newSubs = await repository.fetchFromHtmlApi(page: event.page);

      if (newSubs.isEmpty) {
        _hasReachedEnd = true;
        emit(
          SubscriptionLoaded(
            (state as SubscriptionLoaded?)?.subscriptions ?? [],
            hasReachedEnd: true,
          ),
        );
      } else {
        _currentPage = event.page;
        final current = (state is SubscriptionLoaded)
            ? (state as SubscriptionLoaded).subscriptions
            : [];
        emit(
          SubscriptionLoaded([...current, ...newSubs], hasReachedEnd: false),
        );
      }
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> _onAddSubscription(
    AddSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    await repository.addToLocal(event.subscription);
    add(FetchSubscriptions(page: 1));
  }

  Future<void> _onRemoveSubscription(
    RemoveSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    await repository.removeFromLocal(event.id);
    add(FetchSubscriptions(page: 1));
  }

  Future<void> _onUpdateSubscription(
    UpdateSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    await repository.updateLocal(event.updated);
    add(FetchSubscriptions(page: 1));
  }
}

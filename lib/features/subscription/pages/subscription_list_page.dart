import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsight/features/subscription/bloc/subscription_event.dart';
import 'package:subsight/features/subscription/bloc/subscription_state.dart';
import 'package:subsight/features/subscription/bloc/subscriptoin_bloc.dart';

import 'package:subsight/features/subscription/widgets/subscription_card.dart';
import 'package:subsight/features/subscription/widgets/subscription_input.dart';

class SubscriptionListPage extends StatefulWidget {
  const SubscriptionListPage({super.key});

  @override
  State<SubscriptionListPage> createState() => _SubscriptionListPageState();
}

class _SubscriptionListPageState extends State<SubscriptionListPage> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<SubscriptionBloc>().add(LoadSubscriptions());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SelectableText("Subscriptions")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            enableDrag: true,
            showDragHandle: true,
            context: context,
            builder: (_) {
              return BlocProvider.value(
                value: context.read<SubscriptionBloc>(),
                child: const SubscriptionInput(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading && currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SubscriptionError) {
            return Center(child: SelectableText("Error ${state.message}"));
          } else if (state is SubscriptionLoaded) {
            if (state.subscriptions.isEmpty) {
              return const Center(
                child: SelectableText("No subscriptions found."),
              );
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount:
                  state.subscriptions.length + (state.hasReachedEnd ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.subscriptions.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final subscription = state.subscriptions[index];
                return SubscriptionCard(subscription: subscription);
              },
            );
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
    );
  }
}

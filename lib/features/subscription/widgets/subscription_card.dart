import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsight/features/subscription/bloc/subscription_event.dart';
import 'package:subsight/features/subscription/bloc/subscriptoin_bloc.dart';
import 'package:subsight/features/subscription/models/subscription_model.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;

  const SubscriptionCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(subscription.id.toString()),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        child: ListTile(
          leading: const Icon(Icons.subscriptions),
          title: Text(
            subscription.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            _formatDate(subscription.nextPayment),
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),

      onDismissed: (direction) {
        final bloc = context.read<SubscriptionBloc>();
        final name = subscription.name;
        final subscriptionCopy = subscription;

        bloc.add(RemoveSubscription(subscription.id ?? 0));

        // Delay Snackbar until after Dismissible finishes
        Future.microtask(() {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("$name deleted"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    bloc.add(AddSubscription(subscriptionCopy));
                  },
                ),
              ),
            );
          }
        });
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

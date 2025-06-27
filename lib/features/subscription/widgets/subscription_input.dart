import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsight/features/subscription/bloc/subscription_event.dart';
import 'package:subsight/features/subscription/bloc/subscriptoin_bloc.dart';
import 'package:subsight/features/subscription/models/subscription_model.dart';

class SubscriptionInput extends StatefulWidget {
  const SubscriptionInput({super.key});

  @override
  State<SubscriptionInput> createState() => _SubscriptionInputState();
}

class _SubscriptionInputState extends State<SubscriptionInput> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double price = 0.0;
  String billingCycle = 'Monthly';
  String nextPayment = '';
  String category = '';

  final List<String> billingOptions = [
    'Weekly',
    'Biweekly',
    'Monthly',
    'Yearly',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add Subscription",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: "Name"),
              onChanged: (value) => name = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              onChanged: (value) => price = double.tryParse(value) ?? 0.0,
            ),
            DropdownButtonFormField<String>(
              value: billingCycle,
              items: billingOptions
                  .map(
                    (option) =>
                        DropdownMenuItem(value: option, child: Text(option)),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                billingCycle = value ?? 'Monthly';
              }),
              decoration: const InputDecoration(labelText: "Billing Cycle"),
            ),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Next Payment Date",
                hintText: nextPayment,
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (pickedDate != null) {
                  setState(() {
                    nextPayment = pickedDate.toString();
                  });
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Category"),
              onChanged: (value) => category = value,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  SubscriptionModel subscription = SubscriptionModel(
                    name: name,
                    price: price,
                    billingCycle: billingCycle,
                    category: category,
                    nextPayment: DateTime.parse(nextPayment),
                  );
                  context.read<SubscriptionBloc>().add(
                    AddSubscription(subscription),
                  );

                  // Clear the form fields
                  setState(() {
                    name = '';
                    price = 0.0;
                    billingCycle = 'Monthly';
                    nextPayment = '';
                    category = '';
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Add Subscription"),
            ),
          ],
        ),
      ),
    );
  }
}

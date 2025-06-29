import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:subsight/features/subscription/bloc/subscription_event.dart';
import 'package:subsight/features/subscription/bloc/subscriptoin_bloc.dart';
import 'package:subsight/features/subscription/models/subscription_model.dart';

class SubscriptionInput extends StatefulWidget {
  const SubscriptionInput({super.key, this.subscriptionModel});

  final SubscriptionModel? subscriptionModel;

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
  Icon? icon = null;

  final List<String> billingOptions = [
    'Weekly',
    'Biweekly',
    'Monthly',
    'Yearly',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.subscriptionModel == null
            ? Text('Add Subscription')
            : Text('Edit ${widget.subscriptionModel?.name} subscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120, 120),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        showIconPicker(
                          context,
                          configuration: SinglePickerConfiguration(
                            adaptiveDialog: false,
                            showTooltips: true,
                            iconPickerShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            iconPackModes: const [
                              IconPack.material,
                            ], //TODO: Create icon packs
                            searchComparator:
                                (String search, IconPickerIcon icon) =>
                                    search.toLowerCase().contains(
                                      icon.name
                                          .replaceAll('_', ' ')
                                          .toLowerCase(),
                                    ) ||
                                    icon.name.toLowerCase().contains(
                                      search.toLowerCase(),
                                    ),
                          ),
                        );
                      },
                      child: icon == null
                          ? SizedBox(height: 40, width: 40)
                          : Icon(icon!.icon, size: 40),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      child: Text(
                        "${widget.subscriptionModel?.price ?? 0} €",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  autofocus: true,
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: false,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      price = double.tryParse(value) ?? 0.0;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

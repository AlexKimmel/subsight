import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsight/data/repositories/subscription_repository_impl.dart';
import 'package:subsight/features/subscription/bloc/subscription_event.dart';
import 'package:subsight/features/subscription/bloc/subscriptoin_bloc.dart';
import 'package:subsight/features/subscription/pages/subscription_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = SubscriptionRepositoryImpl();
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (_) => SubscriptionBloc(repository)..add(LoadSubscriptions()),
        child: const SubscriptionListPage(),
      ),
    ),
  );
}

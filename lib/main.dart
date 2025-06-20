import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsight/data/repositories/subscription_repository_impl.dart';
import 'package:subsight/features/subscription/bloc/subscription_event.dart';
import 'package:subsight/features/subscription/bloc/subscriptoin_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = SubscriptionRepositoryImpl();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              SubscriptionBloc(repository)..add(FetchSubscriptions()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

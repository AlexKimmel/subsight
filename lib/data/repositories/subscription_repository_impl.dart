import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:subsight/data/datasources/subscription_db.dart';
import 'package:subsight/features/subscription/bloc/subscription_repository.dart';
import 'package:subsight/features/subscription/models/subscription_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionDB _db = SubscriptionDB();

  @override
  Future<List<SubscriptionModel>> fetchFromHtmlApi({int page = 1}) async {
    final url = Uri.parse(
      "https://alexkimmel.github.io/subsight-api/page=$page",
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to load data");
    }

    final document = html_parser.parse(response.body);
    final elements = document.querySelectorAll('.subscription');

    return elements.map((element) {
      final name = element.querySelector('h2')?.text.trim() ?? '';
      final priceText = element.querySelector('p')?.text ?? '';
      final price =
          double.tryParse(
            RegExp(r'[\d.]+').firstMatch(priceText)?.group(0) ?? '0',
          ) ??
          0.0;
      final category = element.querySelectorAll('p').length > 1
          ? element.querySelectorAll('p')[1].text.trim()
          : 'Uncategorized';

      return SubscriptionModel(
        name: name,
        price: price,
        billingCycle: 'Monthly',
        category: category,
        nextPayment: DateTime.now().add(Duration(days: 30)), // placeholder
      );
    }).toList();
  }

  @override
  Future<void> addToLocal(SubscriptionModel sub) async {
    await _db.insertSubscription(sub);
  }

  @override
  Future<List<SubscriptionModel>> getLocalSubscriptions() async {
    return await _db.getLocalSubscriptions();
  }

  @override
  Future<void> removeFromLocal(int id) async {
    await _db.removeSubscription(id);
  }

  @override
  Future<void> updateLocal(SubscriptionModel sub) async {
    await _db.updateSubscription(sub);
  }
}

import 'dart:convert';

class SubscriptionModel {
  final int? id;
  final String name;
  final double price;
  final String billingCycle;
  final String category;
  final DateTime nextPayment;
  SubscriptionModel({
    this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.category,
    required this.nextPayment,
  });

  SubscriptionModel copyWith({
    int? id,
    String? name,
    double? price,
    String? billingCycle,
    String? category,
    DateTime? nextPayment,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      category: category ?? this.category,
      nextPayment: nextPayment ?? this.nextPayment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'billingCycle': billingCycle,
      'category': category,
      'nextPayment': nextPayment.millisecondsSinceEpoch,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      price: map['price'] as double,
      billingCycle: map['billingCycle'] as String,
      category: map['category'] as String,
      nextPayment: DateTime.fromMillisecondsSinceEpoch(
        map['nextPayment'] as int,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionModel.fromJson(String source) =>
      SubscriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubscriptionModel(id: $id, name: $name, price: $price, billingCycle: $billingCycle, category: $category, nextPayment: $nextPayment)';
  }

  @override
  bool operator ==(covariant SubscriptionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.price == price &&
        other.billingCycle == billingCycle &&
        other.category == category &&
        other.nextPayment == nextPayment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        price.hashCode ^
        billingCycle.hashCode ^
        category.hashCode ^
        nextPayment.hashCode;
  }
}

import 'dart:convert';

class SubscriptionModel {
  final int? id;
  final String name;
  final double price;
  final String billingCycle;
  final String category;
  DateTime nextPayment;
  final DateTime createdAt;
  final bool autoPay;
  final bool notificationsEnabled;
  final DateTime? notificationsInterval;

  bool _hasBeenPayed = false;

  SubscriptionModel({
    this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.category,
    required this.nextPayment,
    required this.createdAt,
    this.notificationsInterval,
    this.autoPay = true,
    this.notificationsEnabled = false,
  });
  void init() {
    if (nextPayment.isBefore(DateTime.now()) && autoPay) {
      _hasBeenPayed = true;
      advancePayment();
    } else {
      _hasBeenPayed = false;
    }
  }

  bool get hasBeenPayed =>
      autoPay ? nextPayment.isBefore(DateTime.now()) : _hasBeenPayed;

  set hasBeenPayed(bool value) {
    if (!autoPay) {
      _hasBeenPayed = value;
      if (value) {
        advancePayment();
      }
    } else {
      throw Exception("Cannot set hasBeenPayed when autoPay is disabled.");
    }
  }

  void advancePayment() {
    if (!autoPay) {
      throw Exception("Cannot advance payment when autoPay is disabled.");
    }
    if (nextPayment.isBefore(DateTime.now())) {
      hasBeenPayed = true;
      switch (billingCycle) {
        case 'Weekly':
          break;
        case 'Biweekly':
          nextPayment = DateTime.now().add(Duration(days: 14));
          break;
        case 'Monthly':
          nextPayment = DateTime.now().add(Duration(days: 30));
          break;
        case 'Quarterly':
          nextPayment = DateTime.now().add(Duration(days: 90));
          break;
        case 'Yearly':
          nextPayment = DateTime.now().add(Duration(days: 365));
          break;
        default:
          throw Exception("Invalid billing cycle: $billingCycle");
      }
    }
  }

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
      createdAt: createdAt,
      notificationsInterval:
          notificationsInterval ?? this.notificationsInterval,
      autoPay: autoPay,
      notificationsEnabled: notificationsEnabled,
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
      'createdAt': createdAt.millisecondsSinceEpoch,
      'autoPay': autoPay,
      'notificationsEnabled': notificationsEnabled,
      'notificationsInterval': notificationsInterval?.millisecondsSinceEpoch,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id'].toString()),
      name: map['name'] as String,
      price: map['price'] as double,
      billingCycle: map['billingCycle'] as String,
      category: map['category'] as String,
      nextPayment: DateTime.fromMillisecondsSinceEpoch(
        map['nextPayment'] is int
            ? map['nextPayment']
            : int.tryParse(map['nextPayment'].toString()) ?? 0,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] is int
            ? map['createdAt']
            : int.tryParse(map['createdAt'].toString()) ?? 0,
      ),
      autoPay: map['autoPay'] as bool? ?? true,
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? false,
      notificationsInterval: map['notificationsInterval'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['notificationsInterval'] is int
                  ? map['notificationsInterval']
                  : int.tryParse(map['notificationsInterval'].toString()) ?? 0,
            )
          : null,
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

import 'restaurant.dart';

class Product {
  final int? id;
  final String name;
  final List<dynamic> restaurants;

  const Product({
    required this.id,
    required this.name,
    required this.restaurants,
  });

  factory Product.fromJson(Map<String, dynamic> map) => Product(
        id: map['id'],
        name: map['name'],
        restaurants: (map['resturants'] as List<dynamic>?)
                ?.map((e) => Restaurant.fromJson(e))
                .toList() ??
            const [],
      );
}

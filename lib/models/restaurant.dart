class Restaurant {
  final int? id;
  final String? image;
  final String name;
  final double latitude;
  final double longitude;
  final List<dynamic> products;

  Restaurant({
    this.id,
    this.image,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.products,
  });

  factory Restaurant.fromJson(Map<String, dynamic> map) => Restaurant(
        id: map['id'],
        image: map['image'],
        name: map['name'],
        latitude: map['latitude'],
        longitude: map['longitude'] as double,
        products: map['products'] as List<dynamic>? ?? [],
      );
}

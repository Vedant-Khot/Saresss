class Saree {
  final String id;
  final String name;
  final String price;
  final String fabric;
  final String color;
  final String stock;
  final String category;
  final String? image;
  final DateTime createdAt;

  Saree({
    required this.id,
    required this.name,
    required this.price,
    required this.fabric,
    required this.color,
    required this.stock,
    required this.category,
    this.image,
    required this.createdAt,
  });

  factory Saree.fromJson(Map<String, dynamic> json) {
    return Saree(
      id: json['id'],
      name: json['name'] ?? 'New Saree',
      price: json['price'] ?? '0',
      fabric: json['fabric'] ?? 'Unknown',
      color: json['color'] ?? 'Unknown',
      stock: json['stock'] ?? '0',
      category: json['category'] ?? 'General',
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'fabric': fabric,
      'color': color,
      'stock': stock,
      'category': category,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

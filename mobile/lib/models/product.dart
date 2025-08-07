class Product {
  final int id;
  final String name;
  final int quantity;
  final DateTime? expiresAt;

  Product({required this.id, required this.name, required this.quantity, this.expiresAt});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
    );
  }
}

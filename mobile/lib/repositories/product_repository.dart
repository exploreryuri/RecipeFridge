import 'services/api_service.dart';
import '../models/product.dart';

class ProductRepository {
  final ApiService _api = ApiService();

  Future<List<Product>> fetchProducts() async {
    final data = await _api.get('/products');
    return (data as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> addProduct(String name, int quantity, DateTime? expiresAt) async {
    final data = await _api.post('/products', {
      'name': name,
      'quantity': quantity,
      'expires_at': expiresAt?.toIso8601String(),
    });
    return Product.fromJson(data);
  }
}

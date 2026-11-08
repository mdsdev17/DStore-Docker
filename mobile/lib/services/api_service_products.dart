import 'package:dio/dio.dart';

import '../models/product_model.dart';

class ApiServiceProducts {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://10.0.2.2:8080/dstore/api/',
      ),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<Product>> getAllProducts() async {
    final response = await _dio.get('products.php');
    final List data = response.data as List;
    return data
        .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final products = await getAllProducts();
    final keyword = query.trim().toLowerCase();
    if (keyword.isEmpty) return products;

    return products.where((product) {
      return product.title.toLowerCase().contains(keyword) ||
          product.category.toLowerCase().contains(keyword) ||
          product.brand.toLowerCase().contains(keyword);
    }).toList();
  }

  Future<Product> getProductById(int id) async {
    final response = await _dio.get(
      'products.php',
      queryParameters: {'id': id},
    );
    return Product.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<Product> createProduct(Product product) async {
    final response = await _dio.post('products.php', data: product.toJson());
    final id = int.parse(response.data['id'].toString());
    return getProductById(id);
  }

  Future<Product> updateProduct(Product product) async {
    await _dio.put(
      'products.php',
      data: {...product.toJson(), 'id': product.id},
    );
    return getProductById(product.id);
  }

  Future<void> deleteProduct(int id) async {
    await _dio.delete('products.php', queryParameters: {'id': id});
  }
}

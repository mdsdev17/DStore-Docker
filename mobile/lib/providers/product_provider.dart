import 'package:flutter/foundation.dart';

import '../models/product_model.dart';
import '../services/api_service_products.dart';

class ProductProvider extends ChangeNotifier {
  final ApiServiceProducts _api = ApiServiceProducts();

  List<Product> _allProducts = [];
  List<Product> _products = [];
  bool _loading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategory;
  int _currentPage = 1;
  final int pageSize = 25;

  List<Product> get products => _products;
  List<Product> get allProducts => _allProducts;
  bool get loading => _loading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;
  int get currentPage => _currentPage;
  int get totalPages {
    final count = _filteredProducts.length;
    return count == 0 ? 1 : (count / pageSize).ceil();
  }

  List<String> get categories {
    final values = _allProducts
        .map((product) => product.category.trim())
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return values;
  }

  List<Product> get _filteredProducts {
    final query = _searchQuery.toLowerCase();
    return _allProducts.where((product) {
      final matchesSearch = query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == null ||
          product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _refreshVisibleProducts() {
    final filtered = _filteredProducts;
    final pages = filtered.isEmpty ? 1 : (filtered.length / pageSize).ceil();

    if (_currentPage > pages) _currentPage = pages;
    if (_currentPage < 1) _currentPage = 1;

    final start = (_currentPage - 1) * pageSize;
    final end = (start + pageSize > filtered.length)
        ? filtered.length
        : start + pageSize;

    _products = start >= filtered.length
        ? []
        : filtered.sublist(start, end);
  }

  Future<void> fetchProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _allProducts = await _api.getAllProducts();
      _currentPage = 1;
      _refreshVisibleProducts();
    } catch (e) {
      _error = 'Gagal mengambil data produk. Periksa IP laptop dan koneksi.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    _searchQuery = query.trim();
    _currentPage = 1;
    _refreshVisibleProducts();
    _error = null;
    notifyListeners();
  }

  void selectCategory(String? category) {
    _selectedCategory = category;
    _currentPage = 1;
    _refreshVisibleProducts();
    notifyListeners();
  }

  void changePage(int page) {
    if (page < 1 || page > totalPages || page == _currentPage) return;
    _currentPage = page;
    _refreshVisibleProducts();
    notifyListeners();
  }

  Future<Product> getProductById(int id) async {
    return _api.getProductById(id);
  }

  Future<void> addProduct(Product product) async {
    _error = null;
    try {
      final createdProduct = await _api.createProduct(product);
      _allProducts.insert(0, createdProduct);
      _currentPage = 1;
      _refreshVisibleProducts();
      notifyListeners();
    } catch (e) {
      _error = 'Gagal menambahkan produk.';
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    _error = null;
    try {
      final updatedProduct = await _api.updateProduct(product);
      final index = _allProducts.indexWhere((item) => item.id == product.id);
      if (index != -1) {
        _allProducts[index] = updatedProduct;
      }
      _refreshVisibleProducts();
      notifyListeners();
    } catch (e) {
      _error = 'Gagal memperbarui produk.';
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    _error = null;
    try {
      await _api.deleteProduct(id);
      _allProducts.removeWhere((product) => product.id == id);
      _refreshVisibleProducts();
      notifyListeners();
    } catch (e) {
      _error = 'Gagal menghapus produk.';
      rethrow;
    }
  }
}

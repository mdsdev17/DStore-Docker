import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';

class ProductEditScreen extends StatefulWidget {
  final int productId;

  const ProductEditScreen({super.key, required this.productId});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _brandController = TextEditingController();
  final _thumbnailController = TextEditingController();

  Product? _product;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final product = await context.read<ProductProvider>().getProductById(
        widget.productId,
      );
      if (!mounted) return;
      _product = product;
      _titleController.text = product.title;
      _descriptionController.text = product.description;
      _categoryController.text = product.category;
      _priceController.text = product.price.toString();
      _brandController.text = product.brand;
      _thumbnailController.text = product.thumbnail;
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat produk')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _brandController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi';
    }
    return null;
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate() || _product == null) return;

    setState(() => _saving = true);

    final updatedProduct = _product!.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      brand: _brandController.text.trim().isEmpty
          ? 'No Brand'
          : _brandController.text.trim(),
      thumbnail: _thumbnailController.text.trim(),
    );

    try {
      await context.read<ProductProvider>().updateProduct(updatedProduct);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui')),
      );
      context.pop(true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui produk')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFAF5),
        title: const Text('Edit Produk'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _product == null
              ? const Center(child: Text('Produk tidak ditemukan'))
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildField(_titleController, 'Nama Produk'),
                      _buildField(_descriptionController, 'Deskripsi', maxLines: 3),
                      _buildField(_categoryController, 'Kategori'),
                      _buildField(
                        _priceController,
                        'Harga',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return 'Masukkan harga yang valid';
                          }
                          return null;
                        },
                      ),
                      _buildField(_brandController, 'Brand'),
                      _buildField(
                        _thumbnailController,
                        'URL Gambar',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'URL gambar wajib diisi';
                          }
                          final uri = Uri.tryParse(value.trim());
                          if (uri == null || !uri.hasScheme ||
                              (uri.scheme != 'http' && uri.scheme != 'https')) {
                            return 'Masukkan URL gambar yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _saving ? null : _saveProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE9E2F8),
                          foregroundColor: const Color(0xFF35313B),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: _saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Simpan Perubahan'),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator ?? _requiredValidator,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _brandController = TextEditingController();
  final _thumbnailController = TextEditingController();
  bool _saving = false;

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

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final product = Product(
      id: 0,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      rating: 0,
      thumbnail: _thumbnailController.text.trim(),
      brand: _brandController.text.trim().isEmpty
          ? 'No Brand'
          : _brandController.text.trim(),
    );

    try {
      await context.read<ProductProvider>().addProduct(product);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan')),
      );
      context.pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan produk')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFAF5),
        title: const Text('Tambah Produk'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildField(_titleController, 'Nama Produk', validator: _requiredValidator),
            _buildField(_descriptionController, 'Deskripsi', maxLines: 3, validator: _requiredValidator),
            _buildField(_categoryController, 'Kategori', validator: _requiredValidator),
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
            _buildField(_brandController, 'Brand (opsional)', required: false),
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
                  : const Text('Simpan Produk'),
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
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: required ? (validator ?? _requiredValidator) : null,
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

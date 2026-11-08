import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController searchController = TextEditingController();

  final Color backgroundColor = const Color(0xFFFFFAF5);
  final Color primaryColor = const Color(0xFFE9E2F8);
  final Color accentColor = const Color(0xFF8066B3);

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    Future.microtask(() => provider.fetchProducts());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match[1]}.')}';
  }

  void _showCategoryDialog(ProductProvider provider) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: const Text(
            'Pilih Kategori',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _categoryChip(
                    label: 'Semua',
                    selected: provider.selectedCategory == null,
                    onTap: () {
                      provider.selectCategory(null);
                      Navigator.pop(dialogContext);
                    },
                  ),
                  ...provider.categories.map(
                    (category) => _categoryChip(
                      label: category,
                      selected: provider.selectedCategory == category,
                      onTap: () {
                        provider.selectCategory(category);
                        Navigator.pop(dialogContext);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _categoryChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? accentColor : const Color(0xFFE4DDEE),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF35313B),
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers(ProductProvider provider) {
    final total = provider.totalPages;
    final current = provider.currentPage;
    final pages = <int>[];

    if (total <= 5) {
      pages.addAll(List.generate(total, (index) => index + 1));
    } else if (current <= 3) {
      pages.addAll([1, 2, 3, -1, total]);
    } else if (current >= total - 2) {
      pages.addAll([1, -1, total - 2, total - 1, total]);
    } else {
      pages.addAll([1, -1, current, -2, total]);
    }

    return pages.map((page) {
      if (page < 0) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Text('...', style: TextStyle(fontWeight: FontWeight.bold)),
        );
      }

      final selected = page == current;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: () => provider.changePage(page),
          borderRadius: BorderRadius.circular(7),
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? accentColor : Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: selected ? accentColor : const Color(0xFFE4DDEE),
              ),
            ),
            child: Text(
              '$page',
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF35313B),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'DStore',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF35313B),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.shopping_bag_outlined, color: Color(0xFF35313B)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: searchController,
              onChanged: (value) =>
                  context.read<ProductProvider>().searchProducts(value),
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/product/add'),
        backgroundColor: primaryColor,
        foregroundColor: const Color(0xFF35313B),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.allProducts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(provider.error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: provider.fetchProducts,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temukan Produk Favoritmu!',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF35313B),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Belanja mudah dengan DStore',
                        style: TextStyle(color: Color(0xFF625B70)),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Semua Produk',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF35313B),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _showCategoryDialog(provider),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE4DDEE)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.category_outlined, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                provider.selectedCategory ?? 'Kategori',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.products.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Produk tidak ditemukan')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final Product product = provider.products[index];

                        return GestureDetector(
                          onTap: () =>
                              context.push('/product/${product.id}'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(14),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      color: const Color(0xFFF5F0FA),
                                      child: Image.network(
                                        product.thumbnail.trim(),
                                        fit: BoxFit.contain,
                                        headers: const {
                                          'User-Agent': 'Mozilla/5.0',
                                        },
                                        loadingBuilder:
                                            (context, child, progress) {
                                          if (progress == null) return child;
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stack) {
                                          return const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        formatPrice(product.price),
                                        style: const TextStyle(
                                          color: Color(0xFF8066B3),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            product.rating.toString(),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: provider.products.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: provider.currentPage > 1
                            ? () => provider.changePage(
                                  provider.currentPage - 1,
                                )
                            : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      ..._buildPageNumbers(provider),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: provider.currentPage < provider.totalPages
                            ? () => provider.changePage(
                                  provider.currentPage + 1,
                                )
                            : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

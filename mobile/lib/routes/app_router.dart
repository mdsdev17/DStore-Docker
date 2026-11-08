import 'package:go_router/go_router.dart';

import '../screens/product_add_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/product_edit_screen.dart';
import '../screens/product_list_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductListScreen(),
    ),
    GoRoute(
      path: '/product/add',
      builder: (context, state) => const ProductAddScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/product/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductEditScreen(productId: id);
      },
    ),
  ],
);

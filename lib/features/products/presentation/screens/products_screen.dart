import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qarto/features/cart/domain/entities/cart_item.dart';
import 'package:qarto/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:qarto/features/cart/presentation/bloc/cart_event.dart';
import 'package:qarto/features/products/domain/entities/product.dart';
import 'package:qarto/features/products/presentation/bloc/product_bloc.dart';
import 'package:qarto/features/products/presentation/bloc/product_event.dart';
import 'package:qarto/features/products/presentation/bloc/product_state.dart';
import 'package:qarto/features/products/presentation/widgets/category_selector.dart';
import 'package:qarto/features/products/presentation/widgets/product_card.dart';
import 'package:qarto/features/products/presentation/widgets/shimmer_product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Wrap everything in a Column so the Category Selector sits at the top
      body: Column(
        children: [
          const SizedBox(height: 10),
          // 1. THE CATEGORY TABS
          const CategorySelector(),
          const SizedBox(height: 10),

          // 2. THE PRODUCT GRID (Expanded to take remaining space)
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => const ShimmerProductCard(),
                  );
                } else if (state is ProductError) {
                  return Center(child: Text(state.message));
                } else if (state is ProductLoaded) {
                  final products = state.products;

                  if (products.isEmpty) {
                    return Center(
                      child: Text(
                        'No products found in this category.',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    onRefresh: () async {
                      context.read<ProductBloc>().add(const LoadProducts());
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            showProductDetailsSheet(context, product);
                          },
                          onAddToCart: () {
                            context.read<CartBloc>().add(
                              AddToCart(
                                CartItem(
                                  productId: product.id,
                                  title: product.title,
                                  price: product.price,
                                  imageUrl: product.imageUrl,
                                  quantity: 1,
                                ),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.title} added to cart'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------------
// BOTTOM SHEET FUNCTION (Placed completely outside the ProductsScreen class)
// ------------------------------------------------------------------------

void showProductDetailsSheet(BuildContext context, Product product) {
  // Grab the current theme state
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.scaffoldBackgroundColor, // Adapts to theme
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.85,
        child: Stack(
          children: [
            // Scrollable Content
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Minimal drag handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 20),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.dividerColor.withOpacity(0.2), // Adapts
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // Large Image (Kept white background to prevent PNG transparency bleed)
                  Center(
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        height: 250,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.broken_image, color: theme.iconTheme.color),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                  color: theme.colorScheme.onSurface, // Adapts
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: theme.colorScheme.onSurface, // Adapts
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Rating Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary, // Adapts
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: theme.colorScheme.onPrimary, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating} (${product.ratingCount} reviews)',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary, // Adapts
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface, // Adapts
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.7), // Adapts
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Sticky "Add to Cart" Button fixed to the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor, // Adapts
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05), // Adapts
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    // We removed the hardcoded style here!
                    // Now it will automatically inherit the beautiful monochrome
                    // ElevatedButtonThemeData we defined in AppTheme.
                    onPressed: () {
                      context.read<CartBloc>().add(
                        AddToCart(
                          CartItem(
                            productId: product.id,
                            title: product.title,
                            price: product.price,
                            imageUrl: product.imageUrl,
                            quantity: 1,
                          ),
                        ),
                      );
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.title} added to cart'),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text(
                      'ADD TO CART',
                      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

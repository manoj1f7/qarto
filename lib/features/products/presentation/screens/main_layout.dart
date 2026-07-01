import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qarto/core/theme/theme_cubit.dart';
import 'package:qarto/features/products/presentation/bloc/product_bloc.dart';
import 'package:qarto/features/products/presentation/bloc/product_event.dart';
import 'package:qarto/features/products/presentation/bloc/product_state.dart';

import 'products_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    ProductsScreen(),
    Center(child: Text('Cart Screen Coming Soon')),
  ];

  void _showSearchBottomSheet(BuildContext context) {
    // Grab the bloc before opening the sheet
    final productBloc = context.read<ProductBloc>();
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // Search TextField
                TextField(
                  autofocus: true,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  onChanged: (query) {
                    productBloc.add(SearchProducts(query));
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // In-Sheet Search Results using BlocBuilder
                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    bloc: productBloc, // Tell it to listen to the existing bloc
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return Center(
                          child: CircularProgressIndicator(color: theme.colorScheme.primary),
                        );
                      } else if (state is ProductLoaded) {
                        if (state.products.isEmpty) {
                          return Center(
                            child: Text(
                              'No products found.',
                              style: TextStyle(color: theme.colorScheme.onSurface),
                            ),
                          );
                        }

                        // Display results as a compact list
                        return ListView.builder(
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              leading: Container(
                                width: 50,
                                height: 50,
                                color: Colors.white,
                                child: CachedNetworkImage(
                                  imageUrl: product.imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              title: Text(
                                product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () {
                                // Close search sheet and open product details
                                Navigator.pop(context);
                                showProductDetailsSheet(context, product);
                              },
                            );
                          },
                        );
                      }

                      // Default state (before typing)
                      return Text(
                        'Type to start searching...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.secondary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      // MAGICAL UX FIX: When the bottom sheet is swiped away, reload the main grid!
      productBloc.add(const LoadProducts());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: theme.iconTheme.color,
          ),
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme(isDark);
          },
        ),
        title: Text('Q A R T O', style: theme.appBarTheme.titleTextStyle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: theme.iconTheme.color),
            onPressed: () => _showSearchBottomSheet(context),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
            child: GNav(
              gap: 8,
              activeColor: theme.colorScheme.onPrimary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: theme.colorScheme.primary,
              color: theme.iconTheme.color,
              tabs: const [
                GButton(icon: Icons.storefront_outlined, text: 'Store'),
                GButton(icon: Icons.shopping_bag_outlined, text: 'Cart'),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

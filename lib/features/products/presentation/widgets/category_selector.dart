import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qarto/features/products/presentation/bloc/product_bloc.dart';
import 'package:qarto/features/products/presentation/bloc/product_event.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int _selectedIndex = 0;

  // FakeStore API categories + "All"
  final List<String> _categories = [
    'All',
    'electronics',
    'jewelery',
    "men's clothing",
    "women's clothing",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          final category = _categories[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });

              // Dispatch the correct event to the Bloc
              if (category == 'All') {
                context.read<ProductBloc>().add(const LoadProducts());
              } else {
                context.read<ProductBloc>().add(LoadProductsByCategory(category));
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                // Monochrome Theme Magic
                color: isSelected ? theme.colorScheme.primary : theme.scaffoldBackgroundColor,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.dividerColor.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

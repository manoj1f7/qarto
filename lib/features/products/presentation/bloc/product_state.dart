import 'package:equatable/equatable.dart';
import 'package:qarto/features/products/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> allProducts; // full fetched list
  final int displayedCount; // how many currently shown

  const ProductLoaded(this.allProducts, {this.displayedCount = 6});

  List<Product> get visibleProducts => allProducts.take(displayedCount).toList();

  bool get hasMore => displayedCount < allProducts.length;

  @override
  List<Object?> get props => [allProducts, displayedCount];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

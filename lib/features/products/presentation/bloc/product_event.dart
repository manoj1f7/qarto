import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}

class LoadProductsByCategory extends ProductEvent {
  final String category;
  const LoadProductsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchProducts extends ProductEvent {
  final String query;
  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

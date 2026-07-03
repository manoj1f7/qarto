import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qarto/features/products/domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);

    on<LoadProductsByCategory>(_onLoadProductsByCategory);

    // Register the Search event with a debounce transformer
    on<SearchProducts>(
      _onSearchProducts,
      transformer: _debounce(const Duration(milliseconds: 300)),
    );
  }

  // Custom Transformer for Debouncing
  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  Future<void> _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) async {
    if (event.query.isEmpty) {
      add(const LoadProducts()); // Reload all if search is cleared
      return;
    }

    emit(ProductLoading());
    // NOTE: FakeStoreAPI doesn't have a direct search endpoint.
    // For this project, you fetch all and filter locally, or pass it to your repository.
    final result = await repository.getAllProducts();

    result.fold((failure) => emit(ProductError(failure.message)), (products) {
      final filtered = products
          .where((p) => p.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(ProductLoaded(filtered));
    });
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    final result = await repository.getAllProducts();

    // fold takes two functions: one for the Left (Failure) and one for the Right (Success)
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }

  void _onLoadMoreProducts(LoadMoreProducts event, Emitter<ProductState> emit) {
    final currentState = state;
    if (currentState is ProductLoaded && currentState.hasMore) {
      emit(
        ProductLoaded(currentState.allProducts, displayedCount: currentState.displayedCount + 6),
      );
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await repository.getProductsByCategory(event.category);

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qarto/features/cart/domain/entities/cart_item.dart';
import 'package:qarto/features/cart/domain/repositories/cart_repository.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc(this.repository) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await repository.getCartItems();
    result.fold((failure) => emit(CartError(failure.message)), (items) => emit(CartLoaded(items)));
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final currentState = state;
    CartItem itemToSave = event.item;

    if (currentState is CartLoaded) {
      final existing = currentState.items.where((i) => i.productId == event.item.productId);
      if (existing.isNotEmpty) {
        itemToSave = existing.first.copyWith(
          quantity: existing.first.quantity + event.item.quantity,
        );
      }
    }

    final result = await repository.addOrUpdateItem(itemToSave);
    result.fold((failure) => emit(CartError(failure.message)), (_) => add(const LoadCart()));
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    final result = await repository.removeItem(event.productId);
    result.fold((failure) => emit(CartError(failure.message)), (_) => add(const LoadCart()));
  }

  Future<void> _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) async {
    if (event.quantity <= 0) {
      add(RemoveFromCart(event.productId));
      return;
    }
    final currentState = state;
    if (currentState is CartLoaded) {
      final item = currentState.items.firstWhere((i) => i.productId == event.productId);
      final updated = item.copyWith(quantity: event.quantity);
      final result = await repository.addOrUpdateItem(updated);
      result.fold((failure) => emit(CartError(failure.message)), (_) => add(const LoadCart()));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final result = await repository.clearCart();
    result.fold((failure) => emit(CartError(failure.message)), (_) => emit(const CartLoaded([])));
  }
}

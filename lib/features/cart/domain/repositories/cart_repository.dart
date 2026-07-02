import 'package:dartz/dartz.dart';
import 'package:qarto/core/error/failures.dart';
import 'package:qarto/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> addOrUpdateItem(CartItem item);
  Future<Either<Failure, void>> removeItem(int productId);
  Future<Either<Failure, void>> clearCart();
}

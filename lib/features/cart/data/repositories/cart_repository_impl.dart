import 'package:dartz/dartz.dart';
import 'package:qarto/core/error/exceptions.dart';
import 'package:qarto/core/error/failures.dart';
import 'package:qarto/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:qarto/features/cart/data/models/cart_item_model.dart';
import 'package:qarto/features/cart/domain/entities/cart_item.dart';
import 'package:qarto/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  CartRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(items);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addOrUpdateItem(CartItem item) async {
    try {
      final model = CartItemModel.fromEntity(item);
      await localDataSource.addOrUpdateItem(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeItem(int productId) async {
    try {
      await localDataSource.removeItem(productId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}

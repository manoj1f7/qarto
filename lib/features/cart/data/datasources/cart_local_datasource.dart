import 'package:hive/hive.dart';
import 'package:qarto/core/error/exceptions.dart';
import 'package:qarto/features/cart/data/models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addOrUpdateItem(CartItemModel item);
  Future<void> removeItem(int productId);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String boxName = 'cartBox';

  Box<CartItemModel> get _box => Hive.box<CartItemModel>(boxName);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      return _box.values.toList();
    } catch (e) {
      throw CacheException('Failed to load cart items.');
    }
  }

  @override
  Future<void> addOrUpdateItem(CartItemModel item) async {
    try {
      await _box.put(item.hiveProductId, item);
    } catch (e) {
      throw CacheException('Failed to save item to cart.');
    }
  }

  @override
  Future<void> removeItem(int productId) async {
    try {
      await _box.delete(productId);
    } catch (e) {
      throw CacheException('Failed to remove item from cart.');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _box.clear();
    } catch (e) {
      throw CacheException('Failed to clear cart.');
    }
  }
}

import 'package:hive/hive.dart';
import 'package:qarto/features/cart/domain/entities/cart_item.dart';
part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemModel extends CartItem {
  @HiveField(0)
  final int hiveProductId;
  @HiveField(1)
  final String hiveTitle;
  @HiveField(2)
  final double hivePrice;
  @HiveField(3)
  final String hiveImageUrl;
  @HiveField(4)
  final int hiveQuantity;

  CartItemModel({
    required this.hiveProductId,
    required this.hiveTitle,
    required this.hivePrice,
    required this.hiveImageUrl,
    required this.hiveQuantity,
  }) : super(
         productId: hiveProductId,
         title: hiveTitle,
         price: hivePrice,
         imageUrl: hiveImageUrl,
         quantity: hiveQuantity,
       );

  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(
      hiveProductId: item.productId,
      hiveTitle: item.title,
      hivePrice: item.price,
      hiveImageUrl: item.imageUrl,
      hiveQuantity: item.quantity,
    );
  }
}

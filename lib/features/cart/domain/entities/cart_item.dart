import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int productId;
  final String title;
  final double price;
  final String imageUrl;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      title: title,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [productId, title, price, imageUrl, quantity];
}

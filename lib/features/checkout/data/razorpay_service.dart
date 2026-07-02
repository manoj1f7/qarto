import 'package:qarto/core/constants/api_constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  final Razorpay _razorpay = Razorpay();

  void init({
    required void Function(PaymentSuccessResponse) onSuccess,
    required void Function(PaymentFailureResponse) onError,
    required void Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void openCheckout({required double amount, required String name, required String description}) {
    final options = {
      'key': ApiConstants.razorpayKey,
      'amount': (amount * 100).toInt(), // Razorpay expects paise, not rupees
      'name': name,
      'description': description,
      'prefill': {'contact': '+919876543210', 'email': 'test@example.com'},
      'theme': {'color': '#000000'},
    };
    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}

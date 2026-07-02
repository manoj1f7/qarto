import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String paymentId;
  final double amount;

  const OrderSuccessScreen({super.key, required this.paymentId, required this.amount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 64),
              ),
              const SizedBox(height: 24),
              Text(
                'Order Placed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your payment was successful',
                style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.6)),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    _buildRow(theme, 'Amount Paid', '\$${amount.toStringAsFixed(2)}'),
                    const SizedBox(height: 12),
                    _buildRow(theme, 'Payment ID', paymentId),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('CONTINUE SHOPPING'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}

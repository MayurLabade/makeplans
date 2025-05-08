import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDetailsScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _startPayment(Map dish) {
    final amount = (int.tryParse(dish['price'].toString()) ?? 0) * 100;

    var options = {
      'key': 'rzp_test_NvskXaQumLXiXZ', // Replace with your Razorpay Key
      'amount': amount,
      'name': widget.restaurant['name'],
      'description': 'Payment for ${dish['name']}',
      'prefill': {
        'contact': '9876543210',
        'email': 'user@example.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('❌ Razorpay open error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Payment successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Payment failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("💼 External wallet selected: ${response.walletName}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List vegMenu = widget.restaurant['veg_menu'] ?? [];
    final List nonVegMenu = widget.restaurant['nonveg_menu'] ?? [];
    final List beverages = widget.restaurant['beverages'] ?? [];
    final bool hasMenu = vegMenu.isNotEmpty || nonVegMenu.isNotEmpty || beverages.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant['name']),
        leading: const BackButton(),
      ),
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.restaurant['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.restaurant['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("Rating: ${widget.restaurant['rating']} ★", style: const TextStyle(color: Colors.grey)),
            Text("Location: ${widget.restaurant['location']}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            const Text("Menu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.cyan)),

            if (!hasMenu)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text("No menu available", style: TextStyle(color: Colors.grey)),
              ),

            if (vegMenu.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text("Veg Dishes 🍀", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
              const SizedBox(height: 8),
              ...vegMenu.map((dish) => _buildMenuItem(dish)).toList(),
            ],

            if (nonVegMenu.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text("Non-Veg Dishes 🍗", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              const SizedBox(height: 8),
              ...nonVegMenu.map((dish) => _buildMenuItem(dish)).toList(),
            ],

            if (beverages.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text("Beverages 🥤", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
              const SizedBox(height: 8),
              ...beverages.map((drink) => _buildMenuItem(drink)).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(Map dish) {
    return GestureDetector(
      onTap: () => _startPayment(dish),
      child: Card(
        color: Colors.grey[850],
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(dish['image'], width: 60, height: 60, fit: BoxFit.cover),
          ),
          title: Text(dish['name'], style: const TextStyle(color: Colors.white)),
          subtitle: Text(dish['description'], style: const TextStyle(color: Colors.grey)),
          trailing: Text("₹${dish['price']}", style: const TextStyle(color: Colors.lightBlueAccent)),
        ),
      ),
    );
  }
}

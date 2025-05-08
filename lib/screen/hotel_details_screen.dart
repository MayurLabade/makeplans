import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HotelDetailScreen extends StatefulWidget {
  final Map hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  late Razorpay _razorpay;
  late Box<String> favoritesBox;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    favoritesBox = Hive.box<String>('favoritesBox');
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _startPayment() {
    final name = widget.hotel['name'] ?? 'Unknown Hotel';
    final price = (int.tryParse(widget.hotel['price'].toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0) * 100;

    var options = {
      'key': 'rzp_test_NvskXaQumLXiXZ',
      'amount': price,
      'name': name,
      'description': 'Hotel booking for $name',
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

  bool isFavorite(String hotelName) {
    return favoritesBox.values.contains(hotelName);
  }

  void toggleFavorite(String hotelName) {
    setState(() {
      if (isFavorite(hotelName)) {
        final key = favoritesBox.keys.firstWhere((k) => favoritesBox.get(k) == hotelName);
        favoritesBox.delete(key);
      } else {
        favoritesBox.add(hotelName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.hotel['name'] ?? 'Unknown Hotel';
    final location = widget.hotel['location'] ?? 'Location not available';
    final imageUrl = widget.hotel['image'] ?? 'https://via.placeholder.com/300';
    final price = widget.hotel['price'] ?? '₹ -';
    final rating = widget.hotel['rating']?.toString() ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite(name) ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => toggleFavorite(name),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image, size: 60)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(location,
                            style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 20, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(price.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('$rating / 5.0',
                          style: const TextStyle(fontSize: 16, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enjoy a luxurious stay with world-class amenities, unmatched service, and a breathtaking view. Perfect for a weekend getaway or a relaxing vacation.",
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _startPayment,
                      icon: const Icon(Icons.phone),
                      label: const Text("Book Now"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

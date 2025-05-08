import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CarRentalScreen extends StatefulWidget {
  const CarRentalScreen({super.key});

  @override
  State<CarRentalScreen> createState() => _CarRentalScreenState();
}

class _CarRentalScreenState extends State<CarRentalScreen> {
  final TextEditingController _locationController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _cars = [];

  final Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _fetchAvailableCars(""); // Fetch all cars initially (empty location)
  }

  @override
  void dispose() {
    _razorpay.clear();
    _locationController.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Payment Successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("👜 Wallet Selected: ${response.walletName}")),
    );
  }

  void _startPayment(Map<String, dynamic> car) {
    final int amount = (int.tryParse(car['price'].toString()) ?? 0) * 100;

    var options = {
      'key': 'rzp_test_NvskXaQumLXiXZ',
      'amount': amount,
      'name': car["make"] + " " + car["model"],
      'description': 'Car Rental Booking',
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

  Future<void> _fetchAvailableCars(String location) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _cars = [];
    });

    try {
      final response = await http.get(
        Uri.parse(
          "https://c3a0-106-195-9-43.ngrok-free.app/makeplans-api/api/cabs/available_rental.php?location=$location",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == true) {
          setState(() {
            _cars = data["cars"];
          });
        } else {
          setState(() {
            _errorMessage = data["message"] ?? "No cars found.";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching data: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildCarCard(Map<String, dynamic> car) {
    String carName = "${car["make"] ?? ""} ${car["model"] ?? ""}";
    int? price = car["price"];
    int? seats = car["seats"];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://tse4.mm.bing.net/th?id=OIP.tIsYATaXWHZxYa6QCd3W1AHaDx&pid=Api&P=0&h=180", // Placeholder image
                width: 100,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.directions_car, size: 60),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Seats: ${seats ?? '-'}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${price ?? '-'} /day",
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _startPayment(car),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text("Book"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Car Rentals"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Enter Location",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final loc = _locationController.text.trim();
                _fetchAvailableCars(loc); // Fetch cars based on the input location
              },
              child: const Text("Search Cars"),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
                  : _cars.isEmpty
                  ? const Center(child: Text("No cars available"))
                  : ListView.builder(
                itemCount: _cars.length,
                itemBuilder: (context, index) {
                  return _buildCarCard(_cars[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

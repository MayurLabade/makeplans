import 'package:flutter/material.dart';

class HotelDetailScreen extends StatelessWidget {
  final Map hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final name = hotel['name'] ?? 'Unknown Hotel';
    final location = hotel['location'] ?? 'Location not available';
    final imageUrl = hotel['image'] ?? 'https://via.placeholder.com/300';
    final price = hotel['price'] ?? '₹ -';
    final rating = hotel['rating']?.toString() ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
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

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name
                  Text(name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 8),

                  // Location
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

                  // Price
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 20, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(price,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('$rating / 5.0',
                          style: const TextStyle(fontSize: 16, color: Colors.black87)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description Placeholder
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

                  // Book Now Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Booking feature coming soon!"),
                        ));
                      },
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

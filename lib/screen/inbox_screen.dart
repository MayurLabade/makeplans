import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  final List<Map<String, String>> _mockMessages = const [
    {
      'icon': '🍽️',
      'title': 'Dinner at Barbeque Nation',
      'subtitle': 'Kalyani Nagar, Apr 20 at 8:00 PM'
    },
    {
      'icon': '🛵',
      'title': 'Paneer Tikka Delivered',
      'subtitle': 'Arrived on Apr 18, 7:30 PM'
    },
    {
      'icon': '🎁',
      'title': 'Loyalty Reward Unlocked',
      'subtitle': 'You earned 50 points!'
    },
    {
      'icon': '🗓️',
      'title': 'Upcoming Reservation',
      'subtitle': 'Rajdhani Thali, Apr 25 at 1:00 PM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: Colors.blue, // ✅ Blue app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: _mockMessages.isEmpty
          ? const Center(
        child: Text(
          'No messages yet!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockMessages.length,
        itemBuilder: (context, index) {
          final message = _mockMessages[index];
          return Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Text(
                message['icon']!,
                style: const TextStyle(fontSize: 28),
              ),
              title: Text(
                message['title']!,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                message['subtitle']!,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}

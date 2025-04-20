import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.cyan), // ✅ Change back button color
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home'); // ✅ Navigate back to HomeScreen
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Your messages will appear here!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}

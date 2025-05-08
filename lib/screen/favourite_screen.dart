import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavouritesScreen extends StatelessWidget {
  final Box<String> favoritesBox = Hive.box<String>('favoritesBox');

  FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ Black background
      appBar: AppBar(
        backgroundColor: Colors.blue, // ✅ Blue top bar
        title: const Text(
          'Your Favorites',
          style: TextStyle(color: Colors.black), // ✅ Title text color black
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Icon also black for contrast
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: favoritesBox.listenable(),
        builder: (context, Box<String> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No favorites added yet.',
                style: TextStyle(color: Colors.white), // ✅ Visible on black background
              ),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final hotelName = box.getAt(index) ?? 'Unknown Hotel';
              return ListTile(
                title: Text(
                  hotelName,
                  style: const TextStyle(color: Colors.white), // ✅ White text
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => box.deleteAt(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavouritesScreen extends StatelessWidget {
  final Box<String> favoritesBox = Hive.box<String>('favoritesBox');

  FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home'); // ✅ Navigates back to HomeScreen
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: favoritesBox.listenable(),
        builder: (context, Box<String> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No favorites added yet.'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final hotelName = box.getAt(index) ?? 'Unknown Hotel';
              return ListTile(
                title: Text(hotelName),
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

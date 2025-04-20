import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/hotel.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final Box<Hotel> favoritesBox = Hive.box<Hotel>('favorites');

  HotelCard({super.key, required this.hotel});

  bool isFavorite() => favoritesBox.containsKey(hotel.name);

  void toggleFavorite(BuildContext context) {
    if (isFavorite()) {
      favoritesBox.delete(hotel.name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from Favorites')),
      );
    } else {
      favoritesBox.put(hotel.name, hotel);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to Favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            hotel.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(hotel.location, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 20),
                    SizedBox(width: 4),
                    Text('${hotel.rating}'),
                    Spacer(),
                    Text('\$${hotel.price} / night',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(
                        isFavorite() ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite() ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => toggleFavorite(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDetailsScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List vegMenu = restaurant['veg_menu'] ?? [];
    final List nonVegMenu = restaurant['nonveg_menu'] ?? [];
    final List beverages = restaurant['beverages'] ?? [];
    final bool hasMenu = vegMenu.isNotEmpty || nonVegMenu.isNotEmpty || beverages.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant['name']),
        leading: const BackButton(),
      ),
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                restaurant['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(restaurant['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("Rating: ${restaurant['rating']} ★", style: const TextStyle(color: Colors.grey)),
            Text("Location: ${restaurant['location']}", style: const TextStyle(color: Colors.grey)),

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
    return Card(
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
    );
  }
}

import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import 'restaurant_detail_screen.dart'; // ✅ Import the correct screen

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final RestaurantService _restaurantService = RestaurantService();
  List<dynamic> _restaurants = [];
  List<dynamic> _recommendedRestaurants = [];
  bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRestaurants('');
  }

  Future<void> fetchRestaurants(String query) async {
    setState(() {
      _isLoading = true;
      _searchQuery = query;
    });

    try {
      final data = await _restaurantService.fetchRestaurants(query);
      setState(() {
        if (query.isEmpty) {
          _recommendedRestaurants = data;
        } else {
          _restaurants = data;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching restaurants: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _searchQuery.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Restaurants'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.redAccent),
          onPressed: () {
            if (_searchController.text.isNotEmpty) {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
                _restaurants = [];
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) => fetchRestaurants(value),
              decoration: InputDecoration(
                labelText: 'Search Restaurants...',
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                labelStyle: const TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: isSearching ? _restaurants.length : _recommendedRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = isSearching ? _restaurants[index] : _recommendedRestaurants[index];
                  final name = restaurant['name'] ?? 'Unknown';
                  final rating = restaurant['rating']?.toString() ?? 'N/A';
                  final location = restaurant['location'] ?? 'Location not available';
                  final imageUrl = restaurant['image'] ?? 'https://via.placeholder.com/150';

                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.restaurant, size: 70, color: Colors.grey),
                        ),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rating: $rating ★', style: const TextStyle(color: Colors.grey)),
                          Text('Location: $location', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailsScreen(restaurant: restaurant),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                        child: const Text('View'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

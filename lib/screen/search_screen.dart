import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'hotel_details_screen.dart'; // Ensure this file exists

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';
  List hotels = [];
  final TextEditingController _searchController = TextEditingController();
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  final bool _clearedOnce = false;

  final uri = Uri.parse('https://edf9-2401-4900-190c-d45f-10f2-4083-de0b-72e3.ngrok-free.app/makeplans-api/api/hotels/hotels.php');

  Future<void> fetchHotels(String query) async {
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['hotels'] != null) {
          List filteredHotels = (data['hotels'] as List).where((hotel) {
            final name = hotel['name']?.toString().toLowerCase() ?? '';
            return name.contains(query.toLowerCase());
          }).toList();

          setState(() {
            hotels = filteredHotels;
          });
        } else {
          setState(() {
            hotels = [];
          });
        }
      } else {
        print('❌ Failed to fetch hotels: ${response.body}');
      }
    } catch (e) {
      print('❌ Error fetching hotels: $e');
    }
  }

  void _handleBackButton() {
    if (_searchController.text.isNotEmpty || hotels.isNotEmpty) {
      setState(() {
        _searchController.clear();
        searchQuery = '';
        hotels = [];
      });
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackButton();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Hotels'),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackButton,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  debouncer.run(() {
                    setState(() {
                      searchQuery = value;
                    });
                    if (value.isNotEmpty) {
                      fetchHotels(value);
                    } else {
                      setState(() {
                        hotels = [];
                      });
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search for hotels...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: hotels.isEmpty
                    ? const Center(child: Text('Enter a search query to see results'))
                    : ListView.builder(
                  itemCount: hotels.length,
                  itemBuilder: (context, index) {
                    final hotel = hotels[index];
                    final name = hotel['name'] ?? 'Unknown Hotel';
                    final location = hotel['location'] ?? 'Location not available';
                    final imageUrl = hotel['image'] ?? 'https://via.placeholder.com/150';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.network(
                              'https://via.placeholder.com/60', // fallback image online
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HotelDetailScreen(hotel: hotel),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

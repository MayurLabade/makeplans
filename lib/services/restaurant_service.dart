import 'dart:convert';
import 'package:http/http.dart' as http;

class RestaurantService {
  final String baseUrl = 'https://cb74-2401-4900-1906-8d55-4908-d059-8928-f13c.ngrok-free.app';

  Future<List<dynamic>> fetchRestaurants(String query) async {
    final Uri uri = Uri.parse('$baseUrl/makeplans-api/api/restaurants/list_restaurants.php');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == true && data['restaurants'] != null) {
        List<dynamic> restaurants = data['restaurants'];

        // Simple local filtering (you already handle this in screen too)
        if (query.isNotEmpty) {
          restaurants = restaurants.where((restaurant) {
            final name = (restaurant['name'] ?? '').toString().toLowerCase();
            return name.contains(query.toLowerCase());
          }).toList();
        }

        return restaurants;
      } else {
        return [];
      }
    } else {
      throw Exception('❌ Failed to fetch restaurants: ${response.body}');
    }
  }

  // Kept for structure, but not needed with static images from your API
  Future<String> fetchRestaurantImage(String placeId) async {
    return 'https://via.placeholder.com/150';
  }
}

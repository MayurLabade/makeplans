import 'dart:convert';
import 'package:http/http.dart' as http;

class RestaurantService {
  final String _baseUrl =
      'https://c3a0-106-195-9-43.ngrok-free.app/makeplans-api/api/restaurants/list_restaurants.php';

  Future<List<dynamic>> fetchRestaurants(String query) async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        print('🟢 Raw response: $jsonBody');

        if (jsonBody['status'] == true && jsonBody['data'] is List) {
          return List<Map<String, dynamic>>.from(jsonBody['data']);
        } else {
          throw Exception('API returned no data: ${jsonBody['message']}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ fetchRestaurants error: $e');
      rethrow;
    }
  }
}

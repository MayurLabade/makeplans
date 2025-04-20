// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class CarRentalService {
//   final String baseUrl = "https://api.foursquare.com/v3/places/search";
//   final String apiKey = "fsq3NXT1L7Ug6ius8JP64u5QAfd4BzhiMBPl0bDZ3wW1wKw="; // Replace with actual API Key
//
//   Future<List<dynamic>> fetchCarRentals({
//     required double latitude,
//     required double longitude,
//   }) async {
//     final url = Uri.parse(
//       "$baseUrl?ll=$latitude,$longitude&query=car rental&limit=10&fields=name,location,rating,photos",
//     );
//
//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           "Authorization": apiKey,
//           "Accept": "application/json",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data["results"] ?? [];
//       } else {
//         throw Exception("Error: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       throw Exception("Error fetching rentals: $e");
//     }
//   }
// }

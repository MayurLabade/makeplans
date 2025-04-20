import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> fetchRegions() async {
  const String url =
      'https://hotels-com-provider.p.rapidapi.com/v2/regions?query=Prag&domain=AR&locale=es_AR';

  const Map<String, String> headers = {
    'x-rapidapi-key': '4870d7b8d5mshdbbcb6cc827d7c4p18f981jsn1d0957184429',
    'x-rapidapi-host': 'hotels-com-provider.p.rapidapi.com',
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Region Details: $data");
    } else {
      print('Failed to load region details: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

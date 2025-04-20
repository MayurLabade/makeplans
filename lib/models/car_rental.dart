class CarRental {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final String phone;
  final String website;
  final String email;
  final String openingHours;

  CarRental({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phone,
    required this.website,
    required this.email,
    required this.openingHours,
  });

  factory CarRental.fromJson(Map<String, dynamic> json) {
    return CarRental(
      id: json['id'].toString(),
      name: json['tags']['name:en'] ?? 'Unknown',
      latitude: json['lat'] ?? 0.0,
      longitude: json['lon'] ?? 0.0,
      address:
      '${json['tags']['addr:housenumber'] ?? ''}, ${json['tags']['addr:street'] ?? ''}',
      phone: json['tags']['phone'] ?? 'No phone available',
      website: json['tags']['website'] ?? 'No website available',
      email: json['tags']['email'] ?? 'No email available',
      openingHours: json['tags']['opening_hours'] ?? 'No hours available',
    );
  }
}

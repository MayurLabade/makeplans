import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'car_rental_screen.dart';
import 'hotel_details_screen.dart';
import 'search_screen.dart';
import 'restaurant_screen.dart';
import 'flight_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _blink = true;
  List hotels = [];
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<String> bannerImages = [
    // 🔁 banner images (unchanged)
    'https://plus.unsplash.com/premium_photo-1661963123153-5471a95b7042?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1517840901100-8179e982acb7?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1661962992065-ce02d11c1d28?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1582484983984-1a930896da01?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=800&q=80',
    'https://plus.unsplash.com/premium_photo-1661874810454-4405e764b706?q=80&w=2123&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1647249893022-9287c83b8cc3?q=80&w=2003&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1717916434101-7f1d246d2b28?q=80&w=2013&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1665464337648-a1736e366b62?q=80&w=1952&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1663293761198-bbab02bd21d8?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1573047330191-fb342b1be381?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1676821792087-240eb2cefd5d?q=80&w=1983&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1721539151779-e6dc7f9de376?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1667125094717-47e0ff6d0608?q=80&w=2063&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1705520354282-a20508c1781f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1739907549777-6ff7cd3921fb?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1680503146476-abb8c752e1f4?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1732347210962-c37cb67aabb2?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1611892440504-42a792e24d32?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1728365743796-ee69341a166d?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  final String apiKey = 'fsq3NXT1L7Ug6ius8JP64u5QAfd4BzhiMBPl0bDZ3wW1wKw=';

  @override
  void initState() {
    super.initState();
    _startBlinking();
    _startBannerAutoScroll();
    _fetchRecommendedHotels();
  }

  void _startBlinking() {
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _blink = !_blink;
      });
    });
  }

  void _startBannerAutoScroll() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % bannerImages.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _fetchRecommendedHotels() async {
    const String apiUrl = 'https://api.foursquare.com/v3/places/search';
    final Uri uri = Uri.parse('$apiUrl?query=hotels&categories=19014&near=India&limit=20');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': apiKey,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List hotelList = data['results'] ?? [];

        hotelList = await Future.wait(hotelList.map((hotel) async {
          String hotelId = hotel['fsq_id'];
          hotel['image_url'] = await _fetchHotelImage(hotelId);
          hotel['rating'] = (hotel['rating'] ?? 4.0).toString();
          hotel['price'] = (hotel['price'] != null) ? '\$${hotel['price']}' : '₹12000';
          hotel['location'] = hotel['location']?['formatted_address'] ?? 'Unknown Location';
          return hotel;
        }));

        setState(() {
          hotels = hotelList;
        });
      }
    } catch (e) {
      print('❌ Error fetching hotels: $e');
    }
  }

  Future<String> _fetchHotelImage(String hotelId) async {
    final Uri uri = Uri.parse('https://api.foursquare.com/v3/places/$hotelId/photos');
    try {
      final response = await http.get(uri, headers: {
        'Authorization': apiKey,
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        List images = json.decode(response.body);
        if (images.isNotEmpty) {
          String prefix = images[0]['prefix'];
          String suffix = images[0]['suffix'];
          return '${prefix}original$suffix';
        }
      }
    } catch (e) {
      print('❌ Image fetch error: $e');
    }
    return 'https://via.placeholder.com/150';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Where To'),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAutoSwipingBanner(),
              const SizedBox(height: 12),

              // ✅ Blinking Text Here
              AnimatedOpacity(
                opacity: _blink ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Center(
                  child: Text(
                    '🔥 Special Offers Just For You!',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text("Trending Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                children: [
                  _buildCategoryCard('Hotels'),
                  _buildCategoryCard('Restaurants'),
                  _buildCategoryCard('Car Rental'),
                  _buildCategoryCard('Flights'),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Recommended Hotels",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: hotels.length,
                itemBuilder: (context, index) {
                  final hotel = hotels[index];
                  final name = hotel['name'] ?? 'Unknown Hotel';
                  final imageUrl = hotel['image_url'];
                  final rating = hotel['rating'];
                  final price = hotel['price'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HotelDetailScreen(hotel: hotel)),
                      );
                    },
                    child: Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/placeholder.png', width: 70, height: 70);
                            },
                          ),
                        ),
                        title: Text(name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text('⭐ $rating | $price', style: const TextStyle(color: Colors.grey)),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAutoSwipingBanner() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: bannerImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  bannerImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/placeholder_banner.png', fit: BoxFit.cover);
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: bannerImages.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.lightBlue,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title) {
    final Map<String, String> categoryImages = {
      'Hotels': 'https://cdn-icons-png.flaticon.com/128/1475/1475996.png',
      'Restaurants': 'https://cdn-icons-png.flaticon.com/128/6643/6643359.png',
      'Car Rental': 'https://cdn-icons-png.flaticon.com/128/9815/9815862.png',
      'Flights': 'https://cdn-icons-png.flaticon.com/128/744/744502.png',
    };

    final imageUrl = categoryImages[title] ?? 'https://via.placeholder.com/100';

    return GestureDetector(
      onTap: () {
        if (title == 'Hotels') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
        } else if (title == 'Restaurants') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const RestaurantScreen()));
        } else if (title == 'Car Rental') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CarRentalScreen()));
        } else if (title == 'Flights') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FlightSearchScreen()));
        }
      },
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              height: 48,
              width: 48,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported, color: Colors.red),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart'; // ✅ new import

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> descriptions = [
    {
      'title': 'Start Your Travel Story Today!',
      'desc': 'Discover breathtaking destinations,\nand create memories that last forever.'
    },
    {
      'title': 'Weekend Getaways',
      'desc': 'Quick escapes to relax.\nDiscover hidden gems around you.\nPerfect for a break from routine.'
    },
    {
      'title': 'Explore the World',
      'desc': 'Travel beyond borders.\nMake memories across the globe.\nAdventure awaits internationally.'
    },
    {
      'title': 'Beach Paradise',
      'desc': 'Soak under the sun.\nWalk endless golden sands.\nFind your beach bliss.'
    },
    {
      'title': 'Mighty Mountains',
      'desc': 'Breathe fresh air.\nTouch the clouds.\nLet mountains calm your soul.'
    },
    {
      'title': 'Romantic Honeymoons',
      'desc': 'Celebrate love in paradise.\nCreate unforgettable moments.\nBegin your forever together.'
    },
    {
      'title': 'Romantic Escapes',
      'desc': 'Perfect spots for lovers.\nSunset dinners, cozy stays,\nand unforgettable views.'
    },
    {
      'title': 'Summer Holidays',
      'desc': 'Splash into sunshine.\nIsland getaways, tropical vibes\nawait you.'
    },
    {
      'title': 'Magical Winters',
      'desc': 'Snowfall, hot chocolates,\ncozy cabins.\nMake memories in magical white lands.'
    },
    {
      'title': 'Monsoon Magic',
      'desc': 'Rain-kissed journeys.\nWaterfalls, misty hills,\nand monsoon romance calling you.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My Trips'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text(
              '+ Add Booking',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Column(
                children: [
                  Text(
                    'No bookings yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Start exploring for your next trip',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            CarouselSlider(
              options: CarouselOptions(
                height: 270,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: [
                _buildSocialCard(),
                _buildCarouselItem('https://i.pinimg.com/originals/de/cb/74/decb747977a9e3dd36933ccdbdf7742f.jpg', 'Weekend'),
                _buildCarouselItem('https://th.bing.com/th/id/OIP.jOY9Q2Tjde4MWVp5L30WWgHaFE?w=232&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7', 'International'),
                _buildCarouselItem('https://wallup.net/wp-content/uploads/2016/05/24/372451-landscape-tropical-beach.jpg', 'Beaches'),
                _buildCarouselItem('https://th.bing.com/th/id/OIP.9ksJWUGUgi_IHsiFkaS39AHaE8?rs=1&pid=ImgDetMain', 'Mountains'),
                _buildCarouselItem('https://th.bing.com/th/id/OIP.AnHMDvfvuFabp7ZKpz4XLAHaE7?rs=1&pid=ImgDetMain', 'Honeymoon'),
                _buildCarouselItem('https://www.oyorooms.com/blog/wp-content/uploads/2018/07/shutterstock_655466914.jpg', 'Romantic'),
                _buildCarouselItem('https://th.bing.com/th/id/OIP.axL-VlLxkqlYafFfvPl8egAAAA?rs=1&pid=ImgDetMain', 'Summer'),
                _buildCarouselItem('https://transform.nws.ai/https://delivery.gettyimages.com/downloads/1175228203.jpg%3Fk%3D6%26e%3DJQZwzoTYHhNJkS7TbzX-Y9tA7rvXoUXvO_HzI5jiHLTFZOvUSEvGPRYldUewskQ261TV9CIDcG46B82wud0hk0AOWT2sXqzglMBT6Pv7ySUEPfVM0MgD5OUc1fOlXe0L/fill/1200/630/', 'Winter'),
                _buildCarouselItem('https://www.oyorooms.com/travel-guide/wp-content/uploads/2019/09/shutterstock_787033735.jpg', 'Monsoon'),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Text(
                    descriptions[_currentIndex]['title'] ?? '',
                    style: GoogleFonts.playfairDisplay( // 🎨 Stylish heading
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      descriptions[_currentIndex]['desc'] ?? '',
                      style: GoogleFonts.raleway( // ✨ Soft description
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Carousel Item
Widget _buildCarouselItem(String imagePath, String title) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      image: DecorationImage(
        image: NetworkImage(imagePath),
        fit: BoxFit.cover,
      ),
    ),
    alignment: Alignment.bottomLeft,
    padding: const EdgeInsets.all(12),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// ✅ Social Card
Widget _buildSocialCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Pack more than memories, Pack Inspirations",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          "Follow us for endless travel inspiration,\ntips and exclusive deals.",
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildSocialButton('Instagram', Colors.pink, FontAwesomeIcons.instagram),
            _buildSocialButton('Facebook', Colors.blue, FontAwesomeIcons.facebook),
            _buildSocialButton('Linkedin', Colors.blueAccent, FontAwesomeIcons.linkedin),
            _buildSocialButton('X', Colors.black, FontAwesomeIcons.xTwitter),
          ],
        ),
      ],
    ),
  );
}

// ✅ Social Button
Widget _buildSocialButton(String title, Color color, IconData icon) {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 9),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

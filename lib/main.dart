import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ✅ Import this

import 'package:makeplans/screen/settings_screen.dart';
import 'package:makeplans/screen/restaurant_screen.dart';
import 'package:makeplans/screen/car_rental_screen.dart';
import 'package:makeplans/screen/splash_screen.dart';
import 'package:makeplans/screen/login_screen.dart';
import 'package:makeplans/screen/register_screen.dart';
import 'package:makeplans/widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase with generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox<String>('favoritesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MakePlans',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      initialRoute: '/splash',
      routes: {
        '/': (context) => const SettingsScreen(),
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const BottomNavBar(),
        '/restaurants': (context) => const RestaurantScreen(),
        '/car_rentals': (context) => const CarRentalScreen(),
      },
    );
  }
}

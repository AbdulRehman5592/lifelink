import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifelink/providers/organ_provider.dart';
import 'package:provider/provider.dart';
import 'package:lifelink/screens/home_screen.dart';
import 'package:lifelink/widgets/custom_appbar.dart';

import 'providers/auth_provider.dart';
import 'providers/blood_donation_provider.dart';
import 'providers/bottom_nav_provider.dart';
import 'providers/medicine_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/blood_donation_screen.dart';
import 'screens/medicine_screen.dart';
import 'screens/organ_screen.dart';
import 'screens/profile_screen.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseService.initialize();
  await FirestoreInitializer.initializeSampleData();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => BloodDonationProvider()),
        ChangeNotifierProvider(
          create: (context) => MedicineProvider()..initialize(),
        ),
        ChangeNotifierProvider(create: (_) => OrganProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeLink',
      theme: ThemeData(
        primaryColor: const Color(0xFF00A89D),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final List<Widget> _screens = const [
    HomeScreen(),
    BloodDonationScreen(),
    MedicineScreen(),
    OrganScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LifeLinkAppBar(), // Use the new AppBar here
      body: IndexedStack(
        index: Provider.of<BottomNavProvider>(context).currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomNavProvider>(context);

    return BottomNavigationBar(
      currentIndex: provider.currentIndex,
      onTap: (index) => provider.currentIndex = index,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF00A89D),
      unselectedItemColor: Colors.grey.shade600,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.bloodtype), label: 'Blood'),
        BottomNavigationBarItem(
          icon: Icon(Icons.medication),
          label: 'Medicine',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Organ'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

class FirestoreInitializer {
  static Future<void> initializeSampleData() async {
    final firestore = FirebaseFirestore.instance;

    // Check if collection exists (has documents)
    final snapshot = await firestore.collection('medicines').limit(1).get();

    if (snapshot.docs.isEmpty) {
      // Add sample medicines
      final sampleMedicines = [
        {
          'name': 'Augmentin',
          'generic': 'Amoxicillin/Clavulanate',
          'category': 'antibiotics',
          'quantity': 10,
          'expiry': 'Dec 2025',
          'donor': 'Sara Ahmed',
          'distance': 0.6,
          'verified': true,
          'postedDate': DateTime.now().millisecondsSinceEpoch,
          'status': 'available',
          'donorId': 'pharmacy_004',
          'images': [],
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        },
        // Add more...
      ];

      for (var medicine in sampleMedicines) {
        await firestore.collection('medicines').add(medicine);
      }
    }
  }
}

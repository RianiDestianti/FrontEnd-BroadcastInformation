// File: lib/screens/save_screen.dart
import 'package:flutter/material.dart';
import '../layouts/layout.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({Key? key}) : super(key: key);

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  // List of events with their saved status
  List<Map<String, dynamic>> events = [
    {
      'title': 'Jam Perpustakaan\nDiperpanjang Selama ...',
      'time': '10:00 AM - 12:00 PM',
      'location': 'Perpustakaan',
      'badgeText': 'Academy',
      'badgeColor': Colors.blue,
      'indicatorColor': Colors.grey,
      'isBookmarked': true,
    },
    {
      'title': 'Upacara Bendera\nHari Senin',
      'time': '10:00 AM - 12:00 PM',
      'location': 'Lapangan Sekolah',
      'badgeText': 'Announcements',
      'badgeColor': Colors.red,
      'indicatorColor': Colors.grey,
      'isBookmarked': true,
    },
    {
      'title': 'Lomba Cerdas Cermat\nAntar Kelas',
      'time': '10:00 AM - 12:00 PM',
      'location': 'Aula Tertutup',
      'badgeText': 'News',
      'badgeColor': Colors.blue,
      'indicatorColor': Colors.grey,
      'isBookmarked': true,
    },
    // Additional events to demonstrate scrolling
    {
      'title': 'Pembagian Rapor\nSemester Ganjil',
      'time': '08:00 AM - 01:00 PM',
      'location': 'Ruang Kelas',
      'badgeText': 'Announcements',
      'badgeColor': Colors.orange,
      'indicatorColor': Colors.grey,
      'isBookmarked': true,
    },
    {
      'title': 'Kompetisi Olahraga\nAntar Sekolah',
      'time': '09:00 AM - 03:00 PM',
      'location': 'Stadion Utama',
      'badgeText': 'Sports',
      'badgeColor': Colors.green,
      'indicatorColor': Colors.grey,
      'isBookmarked': true,
    },
  ];

  void toggleBookmark(int index) {
    setState(() {
      events[index]['isBookmarked'] = !events[index]['isBookmarked'];

      // Optional: Remove from list if unsaved
      if (!events[index]['isBookmarked']) {
        // Show a snackbar notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event telah dihapus dari daftar tersimpan'),
            duration: Duration(seconds: 2),
          ),
        );

        // Delay removal to allow animation to complete
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              events.removeAt(index);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 1, // Karena ini halaman Save
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Record information',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),

              // Event list
              Expanded(
                child:
                    events.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bookmark_border,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Tidak ada item tersimpan',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return Column(
                              children: [
                                InteractiveEventCard(
                                  title: event['title'],
                                  time: event['time'],
                                  location: event['location'],
                                  badgeText: event['badgeText'],
                                  badgeColor: event['badgeColor'],
                                  indicatorColor: event['indicatorColor'],
                                  isBookmarked: event['isBookmarked'],
                                  onBookmarkToggle: () => toggleBookmark(index),
                                ),
                                SizedBox(height: 16),
                              ],
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

// File: lib/widgets/event_card.dart

class InteractiveEventCard extends StatelessWidget {
  final String title;
  final String time;
  final String location;
  final String badgeText;
  final Color badgeColor;
  final Color indicatorColor;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  const InteractiveEventCard({
    Key? key,
    required this.title,
    required this.time,
    required this.location,
    required this.badgeText,
    required this.badgeColor,
    required this.indicatorColor,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left colored indicator
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Time
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Location and bookmark
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        InkWell(
                          onTap: onBookmarkToggle,
                          borderRadius: BorderRadius.circular(50),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                key: ValueKey<bool>(isBookmarked),
                                color: Colors.grey, // <- fix! selalu abu
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Update in your main.dart file to include Poppins font
// Inside the build method of your MyApp class:

@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Color(0xFF57B4BA),
      fontFamily: 'Poppins', // Set default font to Poppins
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    ),
  );
}

// Add this to your pubspec.yaml file to include Poppins font:
/*
fonts:
  - family: Poppins
    fonts:
      - asset: assets/fonts/Poppins-Regular.ttf
      - asset: assets/fonts/Poppins-Medium.ttf
        weight: 500
      - asset: assets/fonts/Poppins-SemiBold.ttf
        weight: 600
      - asset: assets/fonts/Poppins-Bold.ttf
        weight: 700
*/

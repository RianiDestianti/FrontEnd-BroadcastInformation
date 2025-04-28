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
      'date': '26 April 2025',
      'location': 'Perpustakaan',
      'badgeText': 'Academy',
      'badgeColor': Color(0xFF3D5AFE),
      'indicatorColor': Color(0xFF3D5AFE),
      'isBookmarked': true,
    },
    {
      'title': 'Upacara Bendera\nHari Senin',
      'time': '10:00 AM - 12:00 PM',
      'date': '28 April 2025',
      'location': 'Lapangan Sekolah',
      'badgeText': 'Announcements',
      'badgeColor': Color(0xFFFF5252),
      'indicatorColor': Color(0xFFFF5252),
      'isBookmarked': true,
    },
    {
      'title': 'Lomba Cerdas Cermat\nAntar Kelas',
      'time': '10:00 AM - 12:00 PM',
      'date': '30 April 2025',
      'location': 'Aula Tertutup',
      'badgeText': 'News',
      'badgeColor': Color(0xFF00BFA5),
      'indicatorColor': Color(0xFF00BFA5),
      'isBookmarked': true,
    },
    {
      'title': 'Pembagian Rapor\nSemester Ganjil',
      'time': '08:00 AM - 01:00 PM',
      'date': '5 Mei 2025',
      'location': 'Ruang Kelas',
      'badgeText': 'Announcements',
      'badgeColor': Color(0xFFFF9800),
      'indicatorColor': Color(0xFFFF9800),
      'isBookmarked': true,
    },
    {
      'title': 'Kompetisi Olahraga\nAntar Sekolah',
      'time': '09:00 AM - 03:00 PM',
      'date': '12 Mei 2025',
      'location': 'Stadion Utama',
      'badgeText': 'Sports',
      'badgeColor': Color(0xFF4CAF50),
      'indicatorColor': Color(0xFF4CAF50),
      'isBookmarked': true,
    },
  ];

  void toggleBookmark(int index) {
    setState(() {
      events[index]['isBookmarked'] = !events[index]['isBookmarked'];

      // Optional: Remove from list if unsaved
      if (!events[index]['isBookmarked']) {
        final removedEvent = events[index]['title'].split('\n')[0];

        // Show a snackbar notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            backgroundColor: Color(0xFF333333),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            content: Row(
              children: [
                Icon(Icons.bookmark_remove, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$removedEvent telah dihapus',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  ),
                ),
              ],
            ),
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
              Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Saved Items',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '${events.length} items',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Information you\'ve saved for later',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9E9E9E),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Event list
              Expanded(
                child:
                    events.isEmpty
                        ? EmptyStateWidget()
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: EnhancedEventCard(
                                title: event['title'],
                                time: event['time'],
                                date: event['date'],
                                location: event['location'],
                                badgeText: event['badgeText'],
                                badgeColor: event['badgeColor'],
                                indicatorColor: event['indicatorColor'],
                                isBookmarked: event['isBookmarked'],
                                onBookmarkToggle: () => toggleBookmark(index),
                              ),
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

class EmptyStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border,
              size: 64,
              color: Color(0xFF9E9E9E),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No saved items',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3142),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Bookmark items from the home page to see them here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EnhancedEventCard extends StatelessWidget {
  final String title;
  final String time;
  final String date;
  final String location;
  final String badgeText;
  final Color badgeColor;
  final Color indicatorColor;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  const EnhancedEventCard({
    Key? key,
    required this.title,
    required this.time,
    required this.date,
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left colored indicator
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Title and bookmark
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              color: Color(0xFF2D3142),
                              height: 1.3,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onBookmarkToggle,
                          borderRadius: BorderRadius.circular(50),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              transitionBuilder: (
                                Widget child,
                                Animation<double> animation,
                              ) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                key: ValueKey<bool>(isBookmarked),
                                color: indicatorColor,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Event details with icons
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Color(0xFF9E9E9E),
                        ),
                        SizedBox(width: 6),
                        Text(
                          date,
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF9E9E9E),
                        ),
                        SizedBox(width: 6),
                        Text(
                          time,
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF9E9E9E),
                        ),
                        SizedBox(width: 6),
                        Text(
                          location,
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
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

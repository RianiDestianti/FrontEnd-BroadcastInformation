import 'package:flutter/material.dart';
import '../layouts/layout.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({Key? key}) : super(key: key);

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  static const _padding = EdgeInsets.symmetric(horizontal: 20);
  static const _cardBottomMargin = EdgeInsets.only(bottom: 16);
  static const _textPrimaryColor = Color(0xFF2D3142);
  static const _textSecondaryColor = Color(0xFF9E9E9E);
  static const _textTertiaryColor = Color(0xFF666666);
  static const _backgroundColor = Colors.white;
  static const _backgroundSecondaryColor = Color(0xFFF5F5F5);
  static const _shadowColor = Color(0x0D000000);

  final List<EventModel> _events = [
    EventModel(
      title: 'Jam Perpustakaan\nDiperpanjang Selama ...',
      time: '10:00 AM - 12:00 PM',
      date: '26 April 2025',
      location: 'Perpustakaan',
      category: EventCategory(
        name: 'Academy',
        color: const Color(0xFF3D5AFE),
      ),
    ),
    EventModel(
      title: 'Upacara Bendera\nHari Senin',
      time: '10:00 AM - 12:00 PM',
      date: '28 April 2025',
      location: 'Lapangan Sekolah',
      category: EventCategory(
        name: 'Announcements',
        color: const Color(0xFFFF5252),
      ),
    ),
    EventModel(
      title: 'Lomba Cerdas Cermat\nAntar Kelas',
      time: '10:00 AM - 12:00 PM',
      date: '30 April 2025',
      location: 'Aula Tertutup',
      category: EventCategory(
        name: 'News',
        color: const Color(0xFF00BFA5),
      ),
    ),
    EventModel(
      title: 'Pembagian Rapor\nSemester Ganjil',
      time: '08:00 AM - 01:00 PM',
      date: '5 Mei 2025',
      location: 'Ruang Kelas',
      category: EventCategory(
        name: 'Announcements',
        color: const Color(0xFFFF9800),
      ),
    ),
    EventModel(
      title: 'Kompetisi Olahraga\nAntar Sekolah',
      time: '09:00 AM - 03:00 PM',
      date: '12 Mei 2025',
      location: 'Stadion Utama',
      category: EventCategory(
        name: 'Sports',
        color: const Color(0xFF4CAF50),
      ),
    ),
  ];

  void _toggleBookmark(int index) {
    setState(() {
      _events[index].isBookmarked = !_events[index].isBookmarked;

      if (!_events[index].isBookmarked) {
        final removedEvent = _events[index].title.split('\n')[0];
        _showBookmarkRemovedSnackBar(removedEvent);

        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _events.removeAt(index);
            });
          }
        });
      }
    });
  }

  void _showBookmarkRemovedSnackBar(String eventTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: const Color(0xFF333333),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: Row(
          children: [
            const Icon(Icons.bookmark_remove, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$eventTitle telah dihapus',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 1,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSubtitle(),
              const SizedBox(height: 16),
              Expanded(
                child: _events.isEmpty
                    ? const EmptyStateWidget()
                    : _buildEventsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Saved Items',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: _textPrimaryColor,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: _backgroundSecondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Text(
              '${_events.length} items',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _textTertiaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Information you\'ve saved for later',
          style: TextStyle(
            fontSize: 14,
            color: _textSecondaryColor,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    return ListView.builder(
      padding: _padding,
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        return Padding(
          padding: _cardBottomMargin,
          child: EventCard(
            event: event,
            onBookmarkToggle: () => _toggleBookmark(index),
          ),
        );
      },
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({Key? key}) : super(key: key);

  static const _textPrimaryColor = Color(0xFF2D3142);
  static const _textSecondaryColor = Color(0xFF9E9E9E);
  static const _backgroundSecondaryColor = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: _backgroundSecondaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_border,
              size: 64,
              color: _textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No saved items',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Bookmark items from the home page to see them here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: _textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onBookmarkToggle;

  const EventCard({
    Key? key,
    required this.event,
    required this.onBookmarkToggle,
  }) : super(key: key);

  static const _textPrimaryColor = Color(0xFF2D3142);
  static const _textTertiaryColor = Color(0xFF666666);
  static const _iconColor = Color(0xFF9E9E9E);
  static const _shadowColor = Color(0x0D000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: _shadowColor,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _buildColorIndicator(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryBadge(),
                    const SizedBox(height: 12),
                    _buildTitleAndBookmark(),
                    const SizedBox(height: 14),
                    _buildInfoRow(Icons.calendar_today_outlined, event.date),
                    const SizedBox(height: 6),
                    _buildInfoRow(Icons.access_time, event.time),
                    const SizedBox(height: 6),
                    _buildInfoRow(Icons.location_on_outlined, event.location),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorIndicator() {
    return Container(
      width: 6,
      decoration: BoxDecoration(
        color: event.category.color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: event.category.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        event.category.name,
        style: TextStyle(
          color: event.category.color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildTitleAndBookmark() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            event.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              fontFamily: 'Poppins',
              color: _textPrimaryColor,
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
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Icon(
                event.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                key: ValueKey<bool>(event.isBookmarked),
                color: event.category.color,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: _iconColor,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: _textTertiaryColor,
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class EventCategory {
  final String name;
  final Color color;

  const EventCategory({
    required this.name,
    required this.color,
  });
}

class EventModel {
  final String title;
  final String time;
  final String date;
  final String location;
  final EventCategory category;
  bool isBookmarked;

  EventModel({
    required this.title,
    required this.time,
    required this.date,
    required this.location,
    required this.category,
    this.isBookmarked = true,
  });
}
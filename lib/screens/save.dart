import 'package:flutter/material.dart';
import '../layouts/layout.dart';
import '../models/announcement.dart';


class SaveScreen extends StatefulWidget {
  const SaveScreen({Key? key}) : super(key: key);

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final List<EventModel> _events = [
    EventModel(
      title: 'Jam Perpustakaan\nDiperpanjang Selama ...',
      time: '10:00 AM - 12:00 PM',
      date: '26 April 2025',
      location: 'Perpustakaan',
      category: EventCategory(name: 'Academy', color: const Color(0xFF3D5AFE)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              SavedItemsHeader(itemCount: _events.length),
              SavedItemsSubtitle(),
              const SizedBox(height: 16),
              Expanded(
                child:
                    _events.isEmpty
                        ? const EmptyStateWidget()
                        : SavedEventsList(
                          events: _events,
                          onBookmarkToggle: _toggleBookmark,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SavedItemsHeader extends StatelessWidget {
  final int itemCount;
  const SavedItemsHeader({Key? key, required this.itemCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              color: AppColors.textPrimaryColor,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Text(
              '$itemCount items',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SavedItemsSubtitle extends StatelessWidget {
  const SavedItemsSubtitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Information you\'ve saved for later',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondaryColor,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}

class SavedEventsList extends StatelessWidget {
  final List<EventModel> events;
  final Function(int) onBookmarkToggle;

  const SavedEventsList({
    Key? key,
    required this.events,
    required this.onBookmarkToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: EventCard(
            event: event,
            onBookmarkToggle: () => onBookmarkToggle(index),
          ),
        );
      },
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.backgroundSecondaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_border,
              size: 64,
              color: AppColors.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No saved items',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor,
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
                color: AppColors.textSecondaryColor,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            CategoryColorIndicator(color: event.category.color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryBadge(category: event.category),
                    const SizedBox(height: 12),
                    EventTitleBookmark(
                      title: event.title,
                      color: event.category.color,
                      isBookmarked: event.isBookmarked,
                      onBookmarkToggle: onBookmarkToggle,
                    ),
                    const SizedBox(height: 14),
                    EventInfoRow(
                      icon: Icons.calendar_today_outlined,
                      text: event.date,
                    ),
                    const SizedBox(height: 6),
                    EventInfoRow(icon: Icons.access_time, text: event.time),
                    const SizedBox(height: 6),
                    EventInfoRow(
                      icon: Icons.location_on_outlined,
                      text: event.location,
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

class CategoryColorIndicator extends StatelessWidget {
  final Color color;
  const CategoryColorIndicator({Key? key, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
    );
  }
}

class CategoryBadge extends StatelessWidget {
  final EventCategory category;
  const CategoryBadge({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        category.name,
        style: TextStyle(
          color: category.color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

class EventTitleBookmark extends StatelessWidget {
  final String title;
  final Color color;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  const EventTitleBookmark({
    Key? key,
    required this.title,
    required this.color,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              fontFamily: 'Poppins',
              color: AppColors.textPrimaryColor,
              height: 1.3,
            ),
          ),
        ),
        BookmarkButton(
          isBookmarked: isBookmarked,
          color: color,
          onToggle: onBookmarkToggle,
        ),
      ],
    );
  }
}

class BookmarkButton extends StatelessWidget {
  final bool isBookmarked;
  final Color color;
  final VoidCallback onToggle;

  const BookmarkButton({
    Key? key,
    required this.isBookmarked,
    required this.color,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            key: ValueKey<bool>(isBookmarked),
            color: color,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class EventInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const EventInfoRow({Key? key, required this.icon, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.iconColor),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textTertiaryColor,
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class AppColors {
  static const textPrimaryColor = Color(0xFF2D3142);
  static const textSecondaryColor = Color(0xFF9E9E9E);
  static const textTertiaryColor = Color(0xFF666666);
  static const backgroundColor = Colors.white;
  static const backgroundSecondaryColor = Color(0xFFF5F5F5);
  static const shadowColor = Color(0x0D000000);
  static const iconColor = Color(0xFF9E9E9E);
}

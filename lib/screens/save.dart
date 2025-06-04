import 'package:flutter/material.dart';
import '../layouts/layout.dart';
import '../models/model.dart';
import '../constants/constant.dart';

class EventsData {
  static final List<EventCategory> categories = [
    const EventCategory(name: 'Academy', color: Color(0xFF486087)),
    const EventCategory(name: 'Announcements', color: Color(0xFFB35C40)),
    const EventCategory(name: 'News', color: Color(0xFF2C4E57)),
    const EventCategory(name: 'Sports', color: Color.fromARGB(255, 39, 95, 41)),
  ];

  static List<EventModel> getSampleEvents() {
    return [
      EventModel(
        title: 'Jam Perpustakaan\nDiperpanjang Selama ...',
        time: '10:00 AM - 12:00 PM',
        date: '26 April 2025',
        location: 'Perpustakaan',
        category: categories[0],
      ),
      EventModel(
        title: 'Upacara Bendera\nHari Senin',
        time: '10:00 AM - 12:00 PM',
        date: '28 April 2025',
        location: 'Lapangan Sekolah',
        category: categories[1],
      ),
      EventModel(
        title: 'Lomba Cerdas Cermat\nAntar Kelas',
        time: '10:00 AM - 12:00 PM',
        date: '30 April 2025',
        location: 'Aula Tertutup',
        category: categories[2],
      ),
      EventModel(
        title: 'Pembagian Rapor\nSemester Ganjil',
        time: '08:00 AM - 01:00 PM',
        date: '5 Mei 2025',
        location: 'Ruang Kelas',
        category: categories[1],
      ),
      EventModel(
        title: 'Kompetisi Olahraga\nAntar Sekolah',
        time: '09:00 AM - 03:00 PM',
        date: '12 Mei 2025',
        location: 'Stadion Utama',
        category: categories[3],
      ),
    ];
  }
}

class SaveScreen extends StatefulWidget {
  const SaveScreen({Key? key}) : super(key: key);
  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  List<EventModel> _events = EventsData.getSampleEvents();
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
      CustomSnackBar.bookmarkRemoved(eventTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 1,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundPrimary,
        body: SafeArea(
          child: Column(
            children: [
              SavedItemsHeader(itemCount: _events.length),
              const SavedItemsSubtitle(),
              const SizedBox(height: AppTheme.defaultSpacing),
              Expanded(
                child: _events.isEmpty
                    ? const EmptyStateWidget()
                    : EventsList(
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
          const Text('Saved Items', style: AppTheme.titleStyle),
          ItemCountBadge(count: itemCount),
        ],
      ),
    );
  }
}

class ItemCountBadge extends StatelessWidget {
  final int count;
  const ItemCountBadge({Key? key, required this.count}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppTheme.containerRadius),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        '$count items',
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.textTertiary,
        ),
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
          style: AppTheme.subtitleStyle,
        ),
      ),
    );
  }
}

class EventsList extends StatelessWidget {
  final List<EventModel> events;
  final Function(int) onBookmarkToggle;
  const EventsList({
    Key? key,
    required this.events,
    required this.onBookmarkToggle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppTheme.horizontalPadding,
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: AppTheme.cardBottomMargin,
          child: EventCard(
            event: events[index],
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyStateIcon(),
          SizedBox(height: 24),
          EmptyStateTitle(),
          SizedBox(height: 8),
          EmptyStateDescription(),
        ],
      ),
    );
  }
}

class EmptyStateIcon extends StatelessWidget {
  const EmptyStateIcon({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundSecondary,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.bookmark_border,
        size: 64,
        color: AppTheme.textSecondary,
      ),
    );
  }
}

class EmptyStateTitle extends StatelessWidget {
  const EmptyStateTitle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Text(
      'No saved items',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }
}

class EmptyStateDescription extends StatelessWidget {
  const EmptyStateDescription({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        'Bookmark items from the home page to see them here',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppTheme.textSecondary,
        ),
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
      decoration: const BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.all(Radius.circular(AppTheme.cardRadius)),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            EventColorIndicator(color: event.category.color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: EventCardContent(
                  event: event,
                  onBookmarkToggle: onBookmarkToggle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventColorIndicator extends StatelessWidget {
  final Color color;
  const EventColorIndicator({Key? key, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
    );
  }
}

class EventCardContent extends StatelessWidget {
  final EventModel event;
  final VoidCallback onBookmarkToggle;
  const EventCardContent({
    Key? key,
    required this.event,
    required this.onBookmarkToggle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventTitleAndCategory(event: event),
        const SizedBox(height: AppTheme.smallSpacing),
        EventInfoRow(icon: Icons.calendar_today_outlined, text: event.date),
        const SizedBox(height: AppTheme.tinySpacing),
        EventInfoRow(icon: Icons.access_time, text: event.time),
        const SizedBox(height: AppTheme.tinySpacing),
        EventLocationWithBookmark(
          location: event.location,
          isBookmarked: event.isBookmarked,
          onBookmarkToggle: onBookmarkToggle,
        ),
      ],
    );
  }
}

class EventTitleAndCategory extends StatelessWidget {
  final EventModel event;
  const EventTitleAndCategory({Key? key, required this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(event.title, style: AppTheme.cardTitleStyle),
        ),
        const SizedBox(width: AppTheme.smallSpacing),
        EventCategoryBadge(category: event.category),
      ],
    );
  }
}

class EventCategoryBadge extends StatelessWidget {
  final EventCategory category;
  const EventCategoryBadge({Key? key, required this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: category.color,
        borderRadius: BorderRadius.circular(AppTheme.badgeRadius),
        border: Border.all(color: category.color, width: 1),
      ),
      child: Text(
        category.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

class EventInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const EventInfoRow({Key? key, required this.icon, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppTheme.iconColor),
        const SizedBox(width: AppTheme.tinySpacing),
        Text(text, style: AppTheme.infoTextStyle),
      ],
    );
  }
}

class EventLocationWithBookmark extends StatelessWidget {
  final String location;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  const EventLocationWithBookmark({
    Key? key,
    required this.location,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        EventInfoRow(icon: Icons.location_on_outlined, text: location),
        BookmarkButton(
          isBookmarked: isBookmarked,
          onToggle: onBookmarkToggle,
        ),
      ],
    );
  }
}

class BookmarkButton extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onToggle;
  const BookmarkButton({
    Key? key,
    required this.isBookmarked,
    required this.onToggle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            key: ValueKey<bool>(isBookmarked),
            color: AppTheme.iconColor,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class CustomSnackBar {
  static SnackBar bookmarkRemoved(String eventTitle) {
    return SnackBar(
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
    );
  }
}
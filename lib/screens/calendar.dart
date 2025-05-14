import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../layouts/layout.dart';
import '../models/announcement.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  final List<Event> _dummyEvents = [
    Event(
      id: '1',
      title: 'Jam Perpustakaan Diperpanjang',
      description: 'Selama Ujian Akhir',
      category: 'Academic',
      color: const Color(0xFF9db7e0),
    ),
    Event(
      id: '2',
      title: 'Guest Speaker: Kak Adit Santoso',
      description: 'Workshop UI/UX Design',
      category: 'Events',
      color: const Color(0xFFdfed90),
    ),
    Event(
      id: '3',
      title: 'Update Fasilitas Kampus',
      description: 'Renovasi Lab Komputer',
      category: 'News',
      color: const Color(0xFF1665a5),
    ),
    Event(
      id: '4',
      title: 'Jam Perpustakaan Diperpanjang',
      description: 'Selama Periode Ujian Tengah Semester',
      category: 'Academic',
      color: const Color(0xFF9db7e0),
    ),
  ];

  final Map<String, Color> _categoryColors = {
    'Academic': const Color(0xFF9db7e0),
    'Events': const Color(0xFFdfed90),
    'News': const Color(0xFF1665a5),
    'Announcements': const Color(0xFFf08e79),
  };

  @override
  Widget build(BuildContext context) {
    return MainLayout(selectedIndex: 2, child: _buildCalendarContent());
  }

  Widget _buildCalendarContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: CalendarContainer(
                child: Column(
                  children: [
                    MonthNavigation(
                      selectedDate: _selectedDate,
                      onPreviousMonth: _goToPreviousMonth,
                      onNextMonth: _goToNextMonth,
                    ),
                    const SizedBox(height: 24),
                    const WeekdayHeaders(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: CalendarGrid(
                        selectedDate: _selectedDate,
                        categoryColors: _categoryColors,
                        onDayTap: _showEventPopup,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CategoryLegend(categoryColors: _categoryColors),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    });
  }

  void _showEventPopup(BuildContext context, DateTime date) {
    List<Event> eventsForDay = [];

    int day = date.day;
    if (day == 5) {
      eventsForDay.add(_dummyEvents[0]);
    } else if (day == 10) {
      eventsForDay.add(_dummyEvents[1]);
    } else if (day == 13) {
      eventsForDay.add(_dummyEvents[3]);
    } else if (day == 21) {
      eventsForDay.add(_dummyEvents[2]);
    }

    if (eventsForDay.isEmpty) {
      eventsForDay.add(_dummyEvents[0]);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: CalendarEventPopup(date: date, events: eventsForDay),
        );
      },
    );
  }
}

class CalendarContainer extends StatelessWidget {
  final Widget child;
  const CalendarContainer({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: child,
    );
  }
}

class MonthNavigation extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const MonthNavigation({
    Key? key,
    required this.selectedDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MonthDisplay(monthYear: DateFormat('MMMM yyyy').format(selectedDate)),
        Row(
          children: [
            NavigationButton(
              icon: Icons.chevron_left,
              onPressed: onPreviousMonth,
            ),
            const SizedBox(width: 8),
            NavigationButton(icon: Icons.chevron_right, onPressed: onNextMonth),
          ],
        ),
      ],
    );
  }
}

class MonthDisplay extends StatelessWidget {
  final String monthYear;
  const MonthDisplay({Key? key, required this.monthYear}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF57B4BA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        monthYear,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const NavigationButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 24),
        onPressed: onPressed,
      ),
    );
  }
}

class WeekdayHeaders extends StatelessWidget {
  const WeekdayHeaders({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          weekdays
              .map(
                (day) => SizedBox(
                  width: 36,
                  child: Text(
                    day,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
              .toList(),
    );
  }
}

class CalendarGrid extends StatelessWidget {
  final DateTime selectedDate;
  final Map<String, Color> categoryColors;
  final Function(BuildContext, DateTime) onDayTap;

  const CalendarGrid({
    Key? key,
    required this.selectedDate,
    required this.categoryColors,
    required this.onDayTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
    final totalDays = firstWeekdayOfMonth + daysInMonth;
    final rowCount = (totalDays / 7).ceil();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 16,
        crossAxisSpacing: 4,
        childAspectRatio: 0.8,
      ),
      itemCount: rowCount * 7,
      itemBuilder: (context, index) {
        final dayOffset = index - firstWeekdayOfMonth;
        final dayNumber = dayOffset + 1;

        if (dayOffset < 0 || dayNumber > daysInMonth) {
          return Container();
        }

        final currentDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          dayNumber,
        );

        bool hasEvents =
            dayNumber == 5 ||
            dayNumber == 10 ||
            dayNumber == 13 ||
            dayNumber == 21;

        return CalendarDay(
          date: currentDate,
          hasEvents: hasEvents,
          categoryColor: hasEvents ? _getCategoryColorForDay(dayNumber) : null,
          onTap: hasEvents ? () => onDayTap(context, currentDate) : null,
        );
      },
    );
  }

  Color _getCategoryColorForDay(int day) {
    if (day == 5 || day == 13) {
      return categoryColors['Academic']!;
    } else if (day == 10) {
      return categoryColors['Events']!;
    } else if (day == 21) {
      return categoryColors['News']!;
    } else {
      return categoryColors['Announcements']!;
    }
  }
}

class CalendarDay extends StatelessWidget {
  final DateTime date;
  final bool hasEvents;
  final Color? categoryColor;
  final VoidCallback? onTap;

  const CalendarDay({
    Key? key,
    required this.date,
    this.hasEvents = false,
    this.categoryColor,
    this.onTap,
  }) : super(key: key);

  bool get _isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  _isToday
                      ? const Color(0xFFE8F5F6)
                      : hasEvents
                      ? const Color(0xFFF0F9FA)
                      : Colors.transparent,
            ),
            child: Text(
              date.day.toString(),
              style: GoogleFonts.poppins(
                fontWeight: _isToday ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
                color:
                    _isToday
                        ? const Color(0xFF57B4BA)
                        : hasEvents
                        ? const Color(0xFF57B4BA)
                        : Colors.black87,
              ),
            ),
          ),
          if (hasEvents && categoryColor != null)
            Positioned(
              bottom: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class CategoryLegend extends StatelessWidget {
  final Map<String, Color> categoryColors;
  const CategoryLegend({Key? key, required this.categoryColors})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          categoryColors.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: entry.value,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    entry.key,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}

class CalendarEventPopup extends StatelessWidget {
  final DateTime date;
  final List<Event> events;
  const CalendarEventPopup({Key? key, required this.date, required this.events})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
        maxWidth: MediaQuery.of(context).size.width * 0.85,
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateHeader(date: date),
          const SizedBox(height: 20),
          Flexible(child: EventList(events: events)),
          const SizedBox(height: 10),
          const CloseButton(),
        ],
      ),
    );
  }
}

class DateHeader extends StatelessWidget {
  final DateTime date;
  const DateHeader({Key? key, required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF57B4BA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        DateFormat('d MMMM yyyy').format(date),
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}

class EventList extends StatelessWidget {
  final List<Event> events;
  const EventList({Key? key, required this.events}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(event: event);
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({Key? key, required this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryTag(category: event.category, color: event.color),
        const SizedBox(height: 10),
        Text(
          event.title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          event.description,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              print('View details for event ${event.id}');
            },
            child: Text(
              'Lihat deskripsi →',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF57B4BA),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryTag extends StatelessWidget {
  final String category;
  final Color color;
  const CategoryTag({Key? key, required this.category, required this.color})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: category == 'News' ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF50C2C9),
        ),
        child: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

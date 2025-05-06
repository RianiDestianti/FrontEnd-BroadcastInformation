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

  final Map<DateTime, List<Event>> _events = {
    DateTime(2025, 3, 5): [
      Event(
        id: '1',
        title: 'Jam Perpustakaan Diperpanjang',
        description: 'Selama Ujian Akhir',
        category: 'Academic',
        color: const Color(0xFF9db7e0),
      ),
    ],
    DateTime(2025, 3, 10): [
      Event(
        id: '2',
        title: 'Guest Speaker: Kak Adit Santoso',
        description: 'Workshop UI/UX Design',
        category: 'Events',
        color: const Color(0xFFdfed90),
      ),
    ],
    DateTime(2025, 3, 21): [
      Event(
        id: '3',
        title: 'Update Fasilitas Kampus',
        description: 'Renovasi Lab Komputer',
        category: 'News',
        color: const Color(0xFF1665a5),
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 2,
      child: _buildCalendarContent(),
    );
  }

  Widget _buildCalendarContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'kalendar',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
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
                child: Column(
                  children: [
                    _buildMonthNavigation(),
                    const SizedBox(height: 24),
                    _buildWeekdayHeaders(),
                    const SizedBox(height: 20),
                    Expanded(child: _buildCalendarGrid()),
                    const SizedBox(height: 16),
                    _buildEventLegend(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF57B4BA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            DateFormat('MMMM yyyy').format(_selectedDate),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.chevron_left, size: 24),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month - 1,
                      1,
                    );
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.chevron_right, size: 24),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month + 1,
                      1,
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
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

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;

    final firstDayOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      1,
    );
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
          _selectedDate.year,
          _selectedDate.month,
          dayNumber,
        );

        final dateKey = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );
        final hasEvents = _events.containsKey(dateKey);
        final eventsList = hasEvents ? _events[dateKey]! : [];

        return GestureDetector(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isToday(currentDate)
                      ? const Color(0xFFE8F5F6)
                      : Colors.transparent,
                ),
                child: Text(
                  dayNumber.toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: _isToday(currentDate)
                        ? FontWeight.bold
                        : FontWeight.w500,
                    fontSize: 16,
                    color: _isToday(currentDate)
                        ? const Color(0xFF57B4BA)
                        : Colors.black87,
                  ),
                ),
              ),
              if (hasEvents)
                Positioned(
                  bottom: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: eventsList.map((event) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: event.color,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Widget _buildEventLegend() {
    final categories = {
      'Academic': const Color(0xFF9db7e0),
      'Events': const Color(0xFFdfed90),
      'News': const Color(0xFF1665a5),
      'Announcements': const Color(0xFFf08e79),
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: categories.entries.map((entry) {
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

  void _showEventPopup(
    BuildContext context,
    DateTime date,
    List<Event> events,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: CalendarEventPopup(date: date, events: events),
        );
      },
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
          Container(
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
          ),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: events.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final event = events[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: event.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.category,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: event.category == 'News'
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      event.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
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
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF50C2C9),
              ),
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
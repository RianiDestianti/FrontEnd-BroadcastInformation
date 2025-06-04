import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../layouts/layout.dart';
import '../models/model.dart';
import '../constants/constant.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  List<InformasiEvent> _events = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchInformasi();
  }

  Future<void> _fetchInformasi() async {
    try {
      setState(() => _isLoading = true);
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/informasi'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _events = data.map((item) => InformasiEvent.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        _handleError('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('Error fetching data: $e');
    }
  }

  void _handleError(String error) {
    print(error);
    setState(() => _isLoading = false);
  }

  void _navigateMonth(int monthOffset) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + monthOffset,
        1,
      );
    });
  }

  List<InformasiEvent> _getEventsForDate(DateTime date) {
    return _events
        .where(
          (event) =>
              _isDateInRange(date, event.tanggalMulai, event.tanggalSelesai),
        )
        .toList();
  }

  bool _isDateInRange(DateTime date, DateTime startDate, DateTime endDate) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startOnly = DateTime(startDate.year, startDate.month, startDate.day);
    final endOnly = DateTime(endDate.year, endDate.month, endDate.day);

    return dateOnly.isAtSameMomentAs(startOnly) ||
        dateOnly.isAtSameMomentAs(endOnly) ||
        (dateOnly.isAfter(startOnly) && dateOnly.isBefore(endOnly));
  }

  void _showEventPopup(DateTime date) {
    final eventsForDay = _getEventsForDate(date);
    if (eventsForDay.isEmpty) return;
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: CalendarEventPopup(date: date, events: eventsForDay),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 2,
      child: Container(
        color: Colors.white,
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
                : _buildCalendarContent(),
      ),
    );
  }

  Widget _buildCalendarContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: CalendarContainer(
                child: Column(
                  children: [
                    MonthNavigation(
                      selectedDate: _selectedDate,
                      onNavigate: _navigateMonth,
                    ),
                    const SizedBox(height: 24),
                    const WeekdayHeaders(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: CalendarGrid(
                        selectedDate: _selectedDate,
                        events: _events,
                        onDayTap: _showEventPopup,
                        getEventsForDate: _getEventsForDate,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const CategoryLegend(),
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

class InformasiEvent {
  final int id;
  final String judul;
  final String deskripsi;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String thumbnail;
  final String kategori;
  final String operator;
  final DateTime createdAt;
  final DateTime updatedAt;
  const InformasiEvent({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.thumbnail,
    required this.kategori,
    required this.operator,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InformasiEvent.fromJson(Map<String, dynamic> json) {
    return InformasiEvent(
      id: json['IDInformasi'] ?? 0,
      judul: json['Judul'] ?? '',
      deskripsi: json['Deskripsi'] ?? '',
      tanggalMulai: DateTime.parse(
        json['TanggalMulai'] ?? DateTime.now().toString(),
      ),
      tanggalSelesai: DateTime.parse(
        json['TanggalSelesai'] ?? DateTime.now().toString(),
      ),
      thumbnail: json['Thumbnail'] ?? '',
      kategori: CategoryMapper.mapIdToCategory(json['IDKategoriInformasi']),
      operator: json['IDOperator']?.toString() ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toString(),
      ),
    );
  }

  Color get categoryColor => CategoryMapper.getColor(kategori);
}

class CategoryMapper {
  static const Map<String, Color> _categoryColors = {
    'Academic': Color(0xFF9db7e0),
    'Events': Color(0xFFdfed90),
    'News': Color(0xFF1665a5),
    'Announcements': Color(0xFFf08e79),
    'General': Color(0xFF9db7e0),
  };

  static String mapIdToCategory(dynamic kategoriId) {
    switch (kategoriId?.toString()) {
      case '1':
        return 'Academic';
      case '2':
        return 'Events';
      case '3':
        return 'News';
      case '4':
        return 'Announcements';
      default:
        return 'General';
    }
  }

  static Color getColor(String category) =>
      _categoryColors[category] ?? _categoryColors['General']!;

  static Map<String, Color> get categoryColors => _categoryColors;
}

class DateUtils {
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static String formatDateRange(DateTime start, DateTime end) {
    return '${DateFormat('d MMM').format(start)} - ${DateFormat('d MMM yyyy').format(end)}';
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }
}

class CalendarContainer extends StatelessWidget {
  final Widget child;
  const CalendarContainer({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: AppColors.background,
      ),
      child: child,
    );
  }
}

class MonthNavigation extends StatelessWidget {
  final DateTime selectedDate;
  final Function(int) onNavigate;
  const MonthNavigation({
    Key? key,
    required this.selectedDate,
    required this.onNavigate,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MonthDisplay(monthYear: DateUtils.formatMonthYear(selectedDate)),
        Row(
          children: [
            NavigationButton(
              icon: Icons.chevron_left,
              onPressed: () => onNavigate(-1),
            ),
            const SizedBox(width: 8),
            NavigationButton(
              icon: Icons.chevron_right,
              onPressed: () => onNavigate(1),
            ),
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
        color: AppColors.primary,
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
  static const List<String> _weekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          _weekdays
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
  final List<InformasiEvent> events;
  final Function(DateTime) onDayTap;
  final List<InformasiEvent> Function(DateTime) getEventsForDate;

  const CalendarGrid({
    Key? key,
    required this.selectedDate,
    required this.events,
    required this.onDayTap,
    required this.getEventsForDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
    final totalCells = ((firstWeekdayOfMonth + daysInMonth) / 7).ceil() * 7;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 16,
        crossAxisSpacing: 4,
        childAspectRatio: 0.8,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayOffset = index - firstWeekdayOfMonth;
        final dayNumber = dayOffset + 1;

        if (dayOffset < 0 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final currentDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          dayNumber,
        );
        final eventsForDay = getEventsForDate(currentDate);

        return CalendarDay(
          date: currentDate,
          events: eventsForDay,
          onTap: eventsForDay.isNotEmpty ? () => onDayTap(currentDate) : null,
        );
      },
    );
  }
}

class CalendarDay extends StatelessWidget {
  final DateTime date;
  final List<InformasiEvent> events;
  final VoidCallback? onTap;

  const CalendarDay({
    Key? key,
    required this.date,
    required this.events,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isToday(date);
    final hasEvents = events.isNotEmpty;

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
                  isToday
                      ? AppColors.primaryLight
                      : hasEvents
                      ? AppColors.primaryUltraLight
                      : Colors.transparent,
            ),
            child: Text(
              date.day.toString(),
              style: GoogleFonts.poppins(
                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
                color:
                    (isToday || hasEvents) ? AppColors.primary : Colors.black87,
              ),
            ),
          ),
          if (hasEvents)
            Positioned(
              bottom: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:
                    events
                        .take(3)
                        .map(
                          (event) => Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: event.categoryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class CategoryLegend extends StatelessWidget {
  const CategoryLegend({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          CategoryMapper.categoryColors.entries
              .map(
                (entry) => Padding(
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
                ),
              )
              .toList(),
    );
  }
}

class CalendarEventPopup extends StatelessWidget {
  final DateTime date;
  final List<InformasiEvent> events;
  const CalendarEventPopup({Key? key, required this.date, required this.events})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
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
          const PopupCloseButton(),
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
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        DateUtils.formatFullDate(date),
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
  final List<InformasiEvent> events;
  const EventList({Key? key, required this.events}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) => EventCard(event: events[index]),
    );
  }
}

class EventCard extends StatelessWidget {
  final InformasiEvent event;
  const EventCard({Key? key, required this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryTag(category: event.kategori, color: event.categoryColor),
        const SizedBox(height: 10),
        Text(
          event.judul,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          event.deskripsi,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          'Period: ${DateUtils.formatDateRange(event.tanggalMulai, event.tanggalSelesai)}',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => _showDetailDialog(context),
            child: Text(
              'Lihat detail →',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              event.judul,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CategoryTag(
                    category: event.kategori,
                    color: event.categoryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailSection('Description:', event.deskripsi),
                  const SizedBox(height: 12),
                  _buildDetailSection(
                    'Period:',
                    '${DateUtils.formatFullDate(event.tanggalMulai)} - ${DateUtils.formatFullDate(event.tanggalSelesai)}',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(color: AppColors.primary),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(content, style: GoogleFonts.poppins(fontSize: 14)),
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

class PopupCloseButton extends StatelessWidget {
  const PopupCloseButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.cardBackground,
        ),
        child: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

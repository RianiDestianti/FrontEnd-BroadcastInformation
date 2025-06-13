import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../layouts/layout.dart';
import '../models/model.dart';
import '../constants/constant.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
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
        Uri.parse('http://localhost:8000/api/informasi'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _events =
              (json.decode(response.body) as List<dynamic>)
                  .map((item) => InformasiEvent.fromJson(item))
                  .toList();
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
    debugPrint(error);
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
          (_) => Dialog(
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
      selectedIndex: 1,
      child: Container(
        color: Colors.white,
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
                : _CalendarContent(
                  selectedDate: _selectedDate,
                  events: _events,
                  onNavigate: _navigateMonth,
                  onDayTap: _showEventPopup,
                  getEventsForDate: _getEventsForDate,
                ),
      ),
    );
  }
}

class _CalendarContent extends StatelessWidget {
  final DateTime selectedDate;
  final List<InformasiEvent> events;
  final Function(int) onNavigate;
  final Function(DateTime) onDayTap;
  final List<InformasiEvent> Function(DateTime) getEventsForDate;

  const _CalendarContent({
    required this.selectedDate,
    required this.events,
    required this.onNavigate,
    required this.onDayTap,
    required this.getEventsForDate,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: CalendarContainer(
                child: Column(
                  children: [
                    MonthNavigation(
                      selectedDate: selectedDate,
                      onNavigate: onNavigate,
                    ),
                    const SizedBox(height: 24),
                    const WeekdayHeaders(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: CalendarGrid(
                        selectedDate: selectedDate,
                        events: events,
                        onDayTap: onDayTap,
                        getEventsForDate: getEventsForDate,
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
  static const _categoryColors = {
    'Akademik': Color(0xFF6C5CE7),
    'Acara': Color(0xFF45B7D1),
    'Berita': Color(0xFF0984E3),
    'Pengumuman': Color(0xFFE17055),
    'Umum': Colors.orange,
  };

  static String mapIdToCategory(dynamic kategoriId) {
    return switch (kategoriId?.toString()) {
      '1' => 'Akademik',
      '2' => 'Acara',
      '3' => 'Berita',
      '4' => 'Pengumuman',
      _ => 'Umum',
    };
  }

  static Color getColor(String category) =>
      _categoryColors[category] ?? _categoryColors['Umum']!;
  static Map<String, Color> get categoryColors => _categoryColors;
}

class DateUtils {
  static const _indonesianMonths = {
    1: 'Januari',
    2: 'Februari',
    3: 'Maret',
    4: 'April',
    5: 'Mei',
    6: 'Juni',
    7: 'Juli',
    8: 'Agustus',
    9: 'September',
    10: 'Oktober',
    11: 'November',
    12: 'Desember',
  };

  static const _indonesianMonthsShort = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'Mei',
    6: 'Jun',
    7: 'Jul',
    8: 'Agu',
    9: 'Sep',
    10: 'Okt',
    11: 'Nov',
    12: 'Des',
  };

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static String formatDateRange(DateTime start, DateTime end) =>
      '${start.day} ${_indonesianMonthsShort[start.month] ?? ''} - ${end.day} ${_indonesianMonthsShort[end.month] ?? ''} ${end.year}';

  static String formatFullDate(DateTime date) =>
      '${date.day} ${_indonesianMonths[date.month] ?? ''} ${date.year}';

  static String formatMonthYear(DateTime date) =>
      '${_indonesianMonths[date.month] ?? ''} ${date.year}';
}

class CalendarContainer extends StatelessWidget {
  final Widget child;
  const CalendarContainer({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
    super.key,
    required this.selectedDate,
    required this.onNavigate,
  });
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
  const MonthDisplay({super.key, required this.monthYear});
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
    super.key,
    required this.icon,
    required this.onPressed,
  });
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
  const WeekdayHeaders({super.key});
  static const _weekdays = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
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
    super.key,
    required this.selectedDate,
    required this.events,
    required this.onDayTap,
    required this.getEventsForDate,
  });

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

        if (dayOffset < 0 || dayNumber > daysInMonth)
          return const SizedBox.shrink();

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
    super.key,
    required this.date,
    required this.events,
    this.onTap,
  });

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
  const CategoryLegend({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          CategoryMapper.categoryColors.entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
  const CalendarEventPopup({
    super.key,
    required this.date,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
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
  const DateHeader({super.key, required this.date});
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
  const EventList({super.key, required this.events});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) => EventCard(event: events[index]),
    );
  }
}

class EventCard extends StatelessWidget {
  final InformasiEvent event;
  const EventCard({super.key, required this.event});
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
          'Periode: ${DateUtils.formatDateRange(event.tanggalMulai, event.tanggalSelesai)}',
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
      builder: (_) => _EventDetailDialog(event: event),
    );
  }
}

class _EventDetailDialog extends StatelessWidget {
  final InformasiEvent event;
  const _EventDetailDialog({required this.event});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        event.judul,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CategoryTag(category: event.kategori, color: event.categoryColor),
            const SizedBox(height: 12),
            _DetailSection(title: 'Deskripsi:', content: event.deskripsi),
            const SizedBox(height: 12),
            _DetailSection(
              title: 'Periode:',
              content:
                  '${DateUtils.formatFullDate(event.tanggalMulai)} - ${DateUtils.formatFullDate(event.tanggalSelesai)}',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Tutup',
            style: GoogleFonts.poppins(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final String content;
  const _DetailSection({required this.title, required this.content});
  @override
  Widget build(BuildContext context) {
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
  const CategoryTag({super.key, required this.category, required this.color});
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
          color: Colors.white,
        ),
      ),
    );
  }
}

class PopupCloseButton extends StatelessWidget {
  const PopupCloseButton({super.key});
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'popup.dart';
import '../layouts/layout.dart';
import '../models/announcement.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkMode = false;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  List<Announcement> _filteredAnnouncements = [];
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();
  final List<EventBanner> _eventBanners = [
    EventBanner(
      id: '1',
      title: 'SPECTA (Spirit of Creativity and Talent)',
      subtitle: '20 April • Aula Fakultas',
      imageUrl: 'assets/akl.jpg',
      tag: 'Academic',
      tagColor: const Color.fromARGB(255, 4, 9, 18),
    ),
    EventBanner(
      id: '2',
      title: 'EKSIB',
      subtitle: '17 Mei • Gedung Auditorium',
      imageUrl: 'assets/rpl.jpg',
      tag: 'Event',
      tagColor: const Color(0xFFdfed90),
    ),
    EventBanner(
      id: '3',
      title: 'Workshop UI/UX Design',
      subtitle: '18 Mei • Ruang Multimedia',
      imageUrl: 'assets/akl.jpg',
      tag: 'Events',
      tagColor: const Color(0xFFdfed90),
    ),
    EventBanner(
      id: '4',
      title: 'Seminar Nasional IT',
      subtitle: '25 Mei • Auditorium Utama',
      imageUrl: 'assets/akl.jpg',
      tag: 'Academic',
      tagColor: const Color(0xFF9db7e0),
    ),
  ];

  List<Announcement> _allAnnouncements = [];
  bool _isLoading = true;

  final List<CategoryData> _categories = [
    CategoryData(
      name: 'Announcements',
      color: const Color(0xFFB35C40),
      icon: Icons.campaign,
    ),
    CategoryData(
      name: 'Academic',
      color: const Color(0xFF486087),
      icon: Icons.school,
    ),
    CategoryData(
      name: 'Events',
      color: const Color(0xFF95822F),
      icon: Icons.event,
    ),
    CategoryData(
      name: 'News',
      color: const Color(0xFF2C4E57),
      icon: Icons.newspaper,
    ),
    CategoryData(
      name: 'Articles',
      color: const Color(0xFF8A4C6D),
      icon: Icons.article,
    ),
    CategoryData(
      name: 'Calendar',
      color: const Color(0xFF4A7B5B),
      icon: Icons.calendar_today,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredAnnouncements = List.from(_allAnnouncements);
    _searchController.addListener(_filterAnnouncements);
    _setupBannerTimer();
    _fetchInformasi();
  }

  Future<void> _fetchInformasi() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/informasi'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _allAnnouncements =
              data.map((item) => _mapApiToAnnouncement(item)).toList();
          _filteredAnnouncements = List.from(_allAnnouncements);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load informasi');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching informasi: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
      }
    }
  }

  Announcement _mapApiToAnnouncement(Map<String, dynamic> apiData) {
    // Map kategori to appropriate tag and color
    String tag = 'Announcements';
    Color tagColor = const Color(0xFFB35C40);

    // You can customize this mapping based on your kategori data
    if (apiData['IDKategoriInformasi'] != null) {
      switch (apiData['IDKategoriInformasi'].toString()) {
        case '1':
          tag = 'Academic';
          tagColor = const Color(0xFF486087);
          break;
        case '2':
          tag = 'Events';
          tagColor = const Color(0xFF95822F);
          break;
        case '3':
          tag = 'News';
          tagColor = const Color(0xFF2C4E57);
          break;
        default:
          tag = 'Announcements';
          tagColor = const Color(0xFFB35C40);
      }
    }

    String timeAgo = _calculateTimeAgo(apiData['created_at']);

    return Announcement(
      id: apiData['IDInformasi'].toString(),
      tag: tag,
      tagColor: tagColor,
      timeAgo: timeAgo,
      title: apiData['Judul'] ?? 'No Title',
      description: apiData['Deskripsi'] ?? 'No Description',
      fullContent: apiData['Deskripsi'] ?? 'No Content',
      department: 'Dari: ${apiData['IDOperator'] ?? 'Unknown Department'}',
    );
  }

  String _calculateTimeAgo(String? dateString) {
    if (dateString == null) return 'Unknown';

    try {
      DateTime date = DateTime.parse(dateString);
      Duration difference = DateTime.now().difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  Widget _buildAnnouncementsList(double horizontalPadding) {
    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 30,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_filteredAnnouncements.isEmpty) {
      return _buildEmptyState(horizontalPadding);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredAnnouncements.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final announcement = _filteredAnnouncements[index];
        return _buildAnnouncementCard(
          context: context,
          announcement: announcement,
          horizontalPadding: horizontalPadding,
          onTap: () => _showAnnouncementDetail(context, announcement),
        );
      },
    );
  }

  Widget _buildAnnouncementsSection(double horizontalPadding) {
    return RefreshIndicator(
      onRefresh: _fetchInformasi,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnnouncementsHeader(horizontalPadding),
          const SizedBox(height: 16),
          _buildAnnouncementsList(horizontalPadding),
        ],
      ),
    );
  }

  void _setupBannerTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_bannerController.hasClients) {
        final nextPage = (_currentBannerIndex + 1) % _eventBanners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      _setupBannerTimer();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  void _filterAnnouncements() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAnnouncements =
          _allAnnouncements.where((announcement) {
            bool matchesCategory =
                _selectedCategory == null ||
                announcement.tag == _selectedCategory;

            bool matchesQuery =
                query.isEmpty ||
                announcement.title.toLowerCase().contains(query) ||
                announcement.description.toLowerCase().contains(query) ||
                announcement.department.toLowerCase().contains(query) ||
                announcement.tag.toLowerCase().contains(query);

            return matchesCategory && matchesQuery;
          }).toList();
    });
  }

  void _selectCategory(String categoryName) {
    setState(() {
      if (_selectedCategory == categoryName) {
        _selectedCategory = null;
      } else {
        _selectedCategory = categoryName;
      }
      _filterAnnouncements();
    });
  }

  Color _getCategoryColor(String categoryName) {
    final category = _categories.firstWhere(
      (cat) => cat.name == categoryName,
      orElse:
          () => CategoryData(
            name: 'Default',
            color: Colors.grey,
            icon: Icons.circle,
          ),
    );
    return category.color;
  }

  void _showAnnouncementDetail(
    BuildContext context,
    Announcement announcement,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnnouncementDetailPopup(announcement: announcement),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.08;

    return MainLayout(
      selectedIndex: 0,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(horizontalPadding),
                const SizedBox(height: 16),
                _buildSearchBar(horizontalPadding),
                const SizedBox(height: 24),
                _buildBannerSection(horizontalPadding),
                const SizedBox(height: 30),
                _buildCategorySectionHeader(horizontalPadding),
                const SizedBox(height: 16),
                _buildCategoriesScrollView(horizontalPadding),
                const SizedBox(height: 30),
                _buildAnnouncementsHeader(horizontalPadding),
                const SizedBox(height: 16),
                _buildAnnouncementsList(horizontalPadding),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double horizontalPadding) {
    final DateTime now = DateTime.now();
    final String formattedDate = _getFormattedDate(now);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, Ririn!',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formattedDate,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
    );
  }

  String _getFormattedDate(DateTime dateTime) {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final String dayName = days[dateTime.weekday - 1];
    final String monthName = months[dateTime.month - 1];
    return '$dayName, $monthName ${dateTime.day}, ${dateTime.year}';
  }

  Widget _buildBannerSection(double horizontalPadding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            'Upcoming Events',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _eventBanners.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildBannerItem(_eventBanners[index], horizontalPadding);
            },
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _eventBanners.length,
              (index) => _buildPageIndicator(index == _currentBannerIndex),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem(EventBanner banner, double horizontalPadding) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(banner.imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: banner.tagColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                banner.tag,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              banner.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              banner.subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
              
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSearchBar(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 22),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 18,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(26),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySectionHeader(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Categories',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_selectedCategory != null) _buildClearFilterButton(),
        ],
      ),
    );
  }

  Widget _buildClearFilterButton() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          _selectedCategory = null;
          _filterAnnouncements();
        });
      },
      icon: Icon(Icons.close, size: 16, color: Colors.grey[800]),
      label: Text(
        'Clear filter',
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildAnnouncementsHeader(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Announcements',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_selectedCategory != null) _buildFilterIndicator(),
        ],
      ),
    );
  }

  Widget _buildFilterIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Text(
            'Filtered by: ',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _getCategoryColor(_selectedCategory!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _selectedCategory!,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesScrollView(double horizontalPadding) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) => _buildCategoryItem(index),
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    final category = _categories[index];
    final bool isSelected = _selectedCategory == category.name;

    return CategoryItem(
      color: category.color,
      icon: category.icon,
      label: category.name,
      isSelected: isSelected,
      onTap: () => _selectCategory(category.name),
    );
  }

  Widget _buildEmptyState(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 30,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No announcements found',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_selectedCategory != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Try removing the "$_selectedCategory" filter',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard({
    required BuildContext context,
    required Announcement announcement,
    required double horizontalPadding,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnnouncementCardHeader(announcement),
                const SizedBox(height: 12),
                Text(
                  announcement.title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  announcement.description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  announcement.department,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementCardHeader(Announcement announcement) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: announcement.tagColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                announcement.tag,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              announcement.timeAgo,
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        Icon(Icons.bookmark_border, size: 18, color: Colors.grey[400]),
      ],
    );
  }
}

// EventBanner class definition
class EventBanner {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;
  final Color tagColor;

  EventBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
    required this.tagColor,
  });
}

class CategoryData {
  final String name;
  final Color color;
  final IconData icon;

  CategoryData({required this.name, required this.color, required this.icon});
}

class CategoryItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.color,
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconContainer(),
          const SizedBox(height: 8),
          _buildLabelContainer(),
        ],
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: Colors.black, width: 2.5) : null,
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }

  Widget _buildLabelContainer() {
    return SizedBox(
      width: 75,
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.black : Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 16,
              height: 3,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}

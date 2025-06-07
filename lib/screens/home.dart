import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'popup.dart';
import '../layouts/layout.dart';
import '../models/model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controllers and State Variables
  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();

  bool _isDarkMode = false;
  bool _isLoading = true;
  String? _selectedCategory;
  int _currentBannerIndex = 0;

  List<Announcement> _allAnnouncements = [];
  List<Announcement> _filteredAnnouncements = [];

  // Static Data
  static const List<EventBanner> _eventBanners = [
    EventBanner(
      id: '1',
      title: 'SPECTA (Spirit of Creativity and Talent)',
      subtitle: '20 April • Aula Fakultas',
      imageUrl: 'assets/akl.jpg',
      tag: 'Academic',
      tagColor: Color.fromARGB(255, 4, 9, 18),
    ),
    EventBanner(
      id: '2',
      title: 'EKSIB',
      subtitle: '17 Mei • Gedung Auditorium',
      imageUrl: 'assets/rpl.jpg',
      tag: 'Event',
      tagColor: Color(0xFFdfed90),
    ),
    EventBanner(
      id: '3',
      title: 'Workshop UI/UX Design',
      subtitle: '18 Mei • Ruang Multimedia',
      imageUrl: 'assets/akl.jpg',
      tag: 'Events',
      tagColor: Color(0xFFdfed90),
    ),
    EventBanner(
      id: '4',
      title: 'Seminar Nasional IT',
      subtitle: '25 Mei • Auditorium Utama',
      imageUrl: 'assets/akl.jpg',
      tag: 'Academic',
      tagColor: Color(0xFF9db7e0),
    ),
  ];

  static const List<CategoryData> _categories = [
    CategoryData(
      name: 'Announcements',
      color: Color(0xFFB35C40),
      icon: Icons.campaign,
    ),
    CategoryData(
      name: 'Academic',
      color: Color(0xFF486087),
      icon: Icons.school,
    ),
    CategoryData(name: 'Events', color: Color(0xFF95822F), icon: Icons.event),
    CategoryData(name: 'News', color: Color(0xFF2C4E57), icon: Icons.newspaper),
    CategoryData(
      name: 'Articles',
      color: Color(0xFF8A4C6D),
      icon: Icons.article,
    ),
    CategoryData(
      name: 'Calendar',
      color: Color(0xFF4A7B5B),
      icon: Icons.calendar_today,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  // Initialization Methods
  void _initializeData() {
    _filteredAnnouncements = List.from(_allAnnouncements);
    _searchController.addListener(_filterAnnouncements);
    _setupBannerTimer();
    _fetchInformasi();
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

  // API Methods
  Future<void> _fetchInformasi() async {
    try {
      setState(() => _isLoading = true);

      final response = await http.get(
        Uri.parse('http://localhost:8000/api/informasi'),
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
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load data: $e');
    }
  }

  Announcement _mapApiToAnnouncement(Map<String, dynamic> apiData) {
    final categoryMapping = {
      '1': {'tag': 'Academic', 'color': const Color(0xFF486087)},
      '2': {'tag': 'Events', 'color': const Color(0xFF95822F)},
      '3': {'tag': 'News', 'color': const Color(0xFF2C4E57)},
    };

    final categoryId = apiData['IDKategoriInformasi']?.toString();
    final category =
        categoryMapping[categoryId] ??
        {'tag': 'Announcements', 'color': const Color(0xFFB35C40)};

    return Announcement(
      id: apiData['IDInformasi'].toString(),
      tag: category['tag'] as String,
      tagColor: category['color'] as Color,
      timeAgo: _calculateTimeAgo(apiData['created_at']),
      title: apiData['Judul'] ?? 'No Title',
      description: apiData['Deskripsi'] ?? 'No Description',
      fullContent: apiData['Deskripsi'] ?? 'No Content',
      department: 'Dari: ${apiData['IDOperator'] ?? 'Unknown Department'}',
    );
  }

  String _calculateTimeAgo(String? dateString) {
    if (dateString == null) return 'Unknown';

    try {
      final date = DateTime.parse(dateString);
      final difference = DateTime.now().difference(date);

      if (difference.inDays > 0) return '${difference.inDays}d ago';
      if (difference.inHours > 0) return '${difference.inHours}h ago';
      if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
      return 'Just now';
    } catch (e) {
      return 'Unknown';
    }
  }

  // Filter and Selection Methods
  void _filterAnnouncements() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAnnouncements =
          _allAnnouncements.where((announcement) {
            final matchesCategory =
                _selectedCategory == null ||
                announcement.tag == _selectedCategory;
            final matchesQuery =
                query.isEmpty || _matchesSearchQuery(announcement, query);
            return matchesCategory && matchesQuery;
          }).toList();
    });
  }

  bool _matchesSearchQuery(Announcement announcement, String query) {
    return announcement.title.toLowerCase().contains(query) ||
        announcement.description.toLowerCase().contains(query) ||
        announcement.department.toLowerCase().contains(query) ||
        announcement.tag.toLowerCase().contains(query);
  }

  void _selectCategory(String categoryName) {
    setState(() {
      _selectedCategory =
          _selectedCategory == categoryName ? null : categoryName;
      _filterAnnouncements();
    });
  }

  void _clearFilter() {
    setState(() {
      _selectedCategory = null;
      _filterAnnouncements();
    });
  }

  // Utility Methods
  Color _getCategoryColor(String categoryName) {
    return _categories
        .firstWhere(
          (cat) => cat.name == categoryName,
          orElse:
              () => const CategoryData(
                name: 'Default',
                color: Colors.grey,
                icon: Icons.circle,
              ),
        )
        .color;
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _showAnnouncementDetail(Announcement announcement) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: AnnouncementDetailPopup(announcement: announcement),
          ),
    );
  }

  void _toggleDarkMode() {
    setState(() => _isDarkMode = !_isDarkMode);
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
          child: RefreshIndicator(
            onRefresh: _fetchInformasi,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    horizontalPadding: horizontalPadding,
                    isDarkMode: _isDarkMode,
                    onToggleDarkMode: _toggleDarkMode,
                  ),
                  const SizedBox(height: 16),
                  SearchBarWidget(
                    controller: _searchController,
                    horizontalPadding: horizontalPadding,
                  ),
                  const SizedBox(height: 24),
                  BannerSectionWidget(
                    banners: _eventBanners,
                    controller: _bannerController,
                    currentIndex: _currentBannerIndex,
                    horizontalPadding: horizontalPadding,
                    onPageChanged:
                        (index) => setState(() => _currentBannerIndex = index),
                  ),
                  const SizedBox(height: 30),
                  CategorySectionWidget(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    horizontalPadding: horizontalPadding,
                    onCategorySelected: _selectCategory,
                    onClearFilter: _clearFilter,
                  ),
                  const SizedBox(height: 30),
                  AnnouncementsSectionWidget(
                    announcements: _filteredAnnouncements,
                    isLoading: _isLoading,
                    selectedCategory: _selectedCategory,
                    horizontalPadding: horizontalPadding,
                    getCategoryColor: _getCategoryColor,
                    onAnnouncementTap: _showAnnouncementDetail,
                    onClearFilter: _clearFilter,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Data Models
class EventBanner {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;
  final Color tagColor;

  const EventBanner({
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

  const CategoryData({
    required this.name,
    required this.color,
    required this.icon,
  });
}

// Header Widget
class HeaderWidget extends StatelessWidget {
  final double horizontalPadding;
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const HeaderWidget({
    Key? key,
    required this.horizontalPadding,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                _getFormattedDate(DateTime.now()),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              size: 24,
            ),
            onPressed: onToggleDarkMode,
          ),
        ],
      ),
    );
  }

  String _getFormattedDate(DateTime dateTime) {
    const months = [
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

    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final dayName = days[dateTime.weekday - 1];
    final monthName = months[dateTime.month - 1];
    return '$dayName, $monthName ${dateTime.day}, ${dateTime.year}';
  }
}

// Search Bar Widget
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final double horizontalPadding;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 22),
            suffixIcon:
                controller.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 18,
                        color: Colors.grey[500],
                      ),
                      onPressed: controller.clear,
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
}

// Banner Section Widget
class BannerSectionWidget extends StatelessWidget {
  final List<EventBanner> banners;
  final PageController controller;
  final int currentIndex;
  final double horizontalPadding;
  final Function(int) onPageChanged;

  const BannerSectionWidget({
    Key? key,
    required this.banners,
    required this.controller,
    required this.currentIndex,
    required this.horizontalPadding,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            controller: controller,
            itemCount: banners.length,
            onPageChanged: onPageChanged,
            itemBuilder:
                (context, index) => _BannerItem(
                  banner: banners[index],
                  horizontalPadding: horizontalPadding,
                ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => _PageIndicator(isActive: index == currentIndex),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerItem extends StatelessWidget {
  final EventBanner banner;
  final double horizontalPadding;

  const _BannerItem({required this.banner, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
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
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
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
}

// Category Section Widget
class CategorySectionWidget extends StatelessWidget {
  final List<CategoryData> categories;
  final String? selectedCategory;
  final double horizontalPadding;
  final Function(String) onCategorySelected;
  final VoidCallback onClearFilter;

  const CategorySectionWidget({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.horizontalPadding,
    required this.onCategorySelected,
    required this.onClearFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
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
              if (selectedCategory != null)
                _ClearFilterButton(onPressed: onClearFilter),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryItemWidget(
                category: category,
                isSelected: selectedCategory == category.name,
                onTap: () => onCategorySelected(category.name),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ClearFilterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ClearFilterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
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
}

// Category Item Widget
class CategoryItemWidget extends StatelessWidget {
  final CategoryData category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItemWidget({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
              border:
                  isSelected
                      ? Border.all(color: Colors.black, width: 2.5)
                      : null,
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: category.color.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
            child: Icon(category.icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 75,
            child: Column(
              children: [
                Text(
                  category.name,
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
                      color: category.color,
                      borderRadius: BorderRadius.circular(2),
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

// Announcements Section Widget
class AnnouncementsSectionWidget extends StatelessWidget {
  final List<Announcement> announcements;
  final bool isLoading;
  final String? selectedCategory;
  final double horizontalPadding;
  final Color Function(String) getCategoryColor;
  final Function(Announcement) onAnnouncementTap;
  final VoidCallback onClearFilter;

  const AnnouncementsSectionWidget({
    Key? key,
    required this.announcements,
    required this.isLoading,
    required this.selectedCategory,
    required this.horizontalPadding,
    required this.getCategoryColor,
    required this.onAnnouncementTap,
    required this.onClearFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AnnouncementsHeader(
          horizontalPadding: horizontalPadding,
          selectedCategory: selectedCategory,
          getCategoryColor: getCategoryColor,
        ),
        const SizedBox(height: 16),
        _AnnouncementsList(
          announcements: announcements,
          isLoading: isLoading,
          selectedCategory: selectedCategory,
          horizontalPadding: horizontalPadding,
          onAnnouncementTap: onAnnouncementTap,
        ),
      ],
    );
  }
}

class _AnnouncementsHeader extends StatelessWidget {
  final double horizontalPadding;
  final String? selectedCategory;
  final Color Function(String) getCategoryColor;

  const _AnnouncementsHeader({
    required this.horizontalPadding,
    required this.selectedCategory,
    required this.getCategoryColor,
  });

  @override
  Widget build(BuildContext context) {
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
          if (selectedCategory != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Text(
                    'Filtered by: ',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: getCategoryColor(selectedCategory!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedCategory!,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
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

class _AnnouncementsList extends StatelessWidget {
  final List<Announcement> announcements;
  final bool isLoading;
  final String? selectedCategory;
  final double horizontalPadding;
  final Function(Announcement) onAnnouncementTap;

  const _AnnouncementsList({
    required this.announcements,
    required this.isLoading,
    required this.selectedCategory,
    required this.horizontalPadding,
    required this.onAnnouncementTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 30,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (announcements.isEmpty) {
      return _EmptyState(
        horizontalPadding: horizontalPadding,
        selectedCategory: selectedCategory,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: announcements.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return AnnouncementCardWidget(
          announcement: announcement,
          horizontalPadding: horizontalPadding,
          onTap: () => onAnnouncementTap(announcement),
        );
      },
    );
  }
}

// Empty State Widget
class _EmptyState extends StatelessWidget {
  final double horizontalPadding;
  final String? selectedCategory;

  const _EmptyState({
    required this.horizontalPadding,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 40,
      ),
      child: Column(
        children: [
          Icon(Icons.announcement_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            selectedCategory != null
                ? 'No announcements found for "$selectedCategory"'
                : 'No announcements available',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            selectedCategory != null
                ? 'Try selecting a different category or clear the filter.'
                : 'Check back later for new announcements.',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Announcement Card Widget
class AnnouncementCardWidget extends StatelessWidget {
  final Announcement announcement;
  final double horizontalPadding;
  final VoidCallback onTap;

  const AnnouncementCardWidget({
    Key? key,
    required this.announcement,
    required this.horizontalPadding,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: announcement.tagColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    announcement.tag,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  announcement.timeAgo,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              announcement.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              announcement.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (announcement.tag.toLowerCase() == 'urgent' ||
                announcement.tag.toLowerCase() == 'penting') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.priority_high, size: 16, color: Colors.red[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Urgent',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.red[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    // Define category colors here or pass them from parent
    final categoryColors = {
      'Academic': Colors.blue,
      'Event': Colors.green,
      'General': Colors.orange,
      'Emergency': Colors.red,
      'Sports': Colors.purple,
      'Library': Colors.teal,
    };
    return categoryColors[category] ?? Colors.grey;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

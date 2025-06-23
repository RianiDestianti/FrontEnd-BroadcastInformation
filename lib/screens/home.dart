import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login.dart';
import 'popup.dart';
import '../layouts/layout.dart';
import '../models/model.dart';
import '../constants/constant.dart';
import 'tap.dart';
import 'package:flutter/services.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:8000/api';
  static Future<List<Announcement>> fetchAnnouncements(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/informasi'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data
            .map((item) => DataService.mapApiToAnnouncement(item))
            .toList();
      } else {
        throw Exception('Failed to load announcements: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching announcements: $e');
    }
  }

  static Future<List<CategoryData>> fetchCategories(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/kategori'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data.map((item) => DataService.mapApiToCategory(item)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}

class DateService {
  static const List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static String formatDate(DateTime date) {
    return '${_days[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  static String calculateTimeAgo(String? dateString) {
    if (dateString == null) return 'Tidak diketahui';

    try {
      final date = DateTime.parse(dateString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays >= 365) {
        final years = (difference.inDays / 365).floor();
        return '$years tahun lalu';
      } else if (difference.inDays >= 30) {
        final months = (difference.inDays / 30).floor();
        return '$months bulan lalu';
      } else if (difference.inDays >= 7) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks minggu lalu';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} hari lalu';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} jam lalu';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} menit lalu';
      } else if (difference.inSeconds > 0) {
        return '${difference.inSeconds} detik lalu';
      } else {
        return 'Baru saja';
      }
    } catch (e) {
      return 'Tidak diketahui';
    }
  }
}

class DataService {
  static const List<EventBanner> banners = [
    EventBanner(
      id: '1',
      title: 'PAS (Penilaian Akhir Semester Genap)',
      subtitle: '20 April • Ruang AKL01',
      imageUrl: 'assets/akl.jpg',
      tag: 'Akademik',
      tagColor: Color(0xFF0984E3),
    ),
    EventBanner(
      id: '2',
      title: 'Semarak Class Meeting 2025',
      subtitle: '17 Mei • Lapangan SMKN 11 Bandung',
      imageUrl: 'assets/rpl.jpg',
      tag: 'Acara',
      tagColor: Color(0xFF6C5CE7),
    ),
    EventBanner(
      id: '3',
      title: 'Workshop VR DKV',
      subtitle: '18 Mei • Lab Multimedia',
      imageUrl: 'assets/dkvaja.jpg',
      tag: 'Umum',
      tagColor: Color(0xFF45B7D1),
    ),
    EventBanner(
      id: '4',
      title: 'Pemaparan Materi oleh PT Cakrawala',
      subtitle: '25 Mei • TEFA Perkantoran',
      imageUrl: 'assets/otkpbiru.jpg',
      tag: 'Umum',
      tagColor: Color(0xFF45B7D1),
    ),
  ];

  static Map<String, Map<String, dynamic>> _categoryMapping = {};
  static List<CategoryData> _categories = [];
  static void updateCategoryMapping(List<CategoryData> categories) {
    _categories = categories;
    _categoryMapping = {
      for (var i = 0; i < categories.length; i++)
        (i + 1).toString(): {
          'tag': categories[i].name,
          'color': categories[i].color,
        },
    };
  }

  static const Map<String, String> _departmentMapping = {
    '1': 'Kesiswaan',
    '2': 'SDM',
    '3': 'Hubin',
    '4': 'Kurikulum',
    '5': 'Tata Usaha',
  };

  static CategoryData mapApiToCategory(Map<String, dynamic> apiData) {
    const List<Color> colors = [
      Color(0xFFE17055),
      Color(0xFF6C5CE7),
      Color(0xFF45B7D1),
      Color(0xFF0984E3),
      Color(0xFFFDCB6E),
    ];
    const List<IconData> icons = [
      Icons.campaign,
      Icons.school,
      Icons.event,
      Icons.newspaper,
      Icons.info,
    ];

    final int index =
        ((apiData['IDKategoriInformasi'] as int) - 1) % colors.length;

    return CategoryData(
      name: apiData['NamaKategori'] ?? 'Unknown',
      color: colors[index],
      icon: icons[index],
      description: apiData['Deskripsi'] ?? 'No description available',
    );
  }

  static Announcement mapApiToAnnouncement(Map<String, dynamic> apiData) {
    final categoryId = apiData['IDKategoriInformasi']?.toString();
    final category =
        _categoryMapping[categoryId] ??
        {'tag': 'Pengumuman Sekolah', 'color': const Color(0xFFE17055)};

    final operatorId = apiData['IDOperator']?.toString();
    final departmentName =
        _departmentMapping[operatorId] ?? 'Departemen Tidak Dikenal';

    return Announcement(
      id: apiData['IDInformasi'].toString(),
      tag: category['tag'] as String,
      tagColor: category['color'] as Color,
      timeAgo: DateService.calculateTimeAgo(apiData['created_at']),
      title: apiData['Judul'] ?? 'Tidak Ada Judul',
      description: apiData['Deskripsi'] ?? 'Tidak Ada Deskripsi',
      fullContent: apiData['Deskripsi'] ?? 'Tidak Ada Konten',
      department: departmentName,
      thumbnail: apiData['Thumbnail'] ?? 'placeholder.jpg',
      imageUrl: apiData['Thumbnail'],
    );
  }

  static Color getCategoryColor(String categoryName) {
    return _categories
        .firstWhere(
          (cat) => cat.name == categoryName,
          orElse:
              () => const CategoryData(
                name: 'Bawaan',
                color: Colors.grey,
                icon: Icons.circle,
                description: 'Default category',
              ),
        )
        .color;
  }

  static String getDepartmentName(String operatorId) {
    return _departmentMapping[operatorId] ?? 'Departemen Tidak Dikenal';
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();
  bool _isLoading = true;
  String? _selectedCategory;
  int _currentBannerIndex = 0;
  List<Announcement> _allAnnouncements = [];
  List<Announcement> _filteredAnnouncements = [];
  List<CategoryData> _categories = [];
  String? _userName;
  String? _authToken;
  bool _showCategoryTooltip = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
    _checkTooltipStatus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _checkTooltipStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTooltip = prefs.getBool('has_seen_category_tooltip') ?? false;
    if (!hasSeenTooltip) {
      setState(() => _showCategoryTooltip = true);
      await Future.delayed(const Duration(seconds: 8), () {
        if (mounted) {
          setState(() => _showCategoryTooltip = false);
          prefs.setBool('has_seen_category_tooltip', true);
        }
      });
    }
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final name = prefs.getString('nama');

    if (token == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInPage()),
        );
      }
      return;
    }

    setState(() {
      _authToken = token;
      _userName = name ?? 'User';
    });

    final profile = await AuthService.getProfile();
    if (profile == null) {
      await prefs.clear();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInPage()),
        );
      }
      return;
    }
    _initializeData();
  }

  Future<void> _initializeData() async {
    _filteredAnnouncements = List.from(_allAnnouncements);
    _searchController.addListener(_filterAnnouncements);
    _setupBannerTimer();
    await _fetchCategories();
    await _fetchAnnouncements();
  }

  void _setupBannerTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_bannerController.hasClients && mounted) {
        final nextPage = (_currentBannerIndex + 1) % DataService.banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() => _currentBannerIndex = nextPage);
        _setupBannerTimer();
      }
    });
  }

  Future<void> _fetchCategories() async {
    if (_authToken == null) return;
    setState(() => _isLoading = true);
    try {
      final categories = await ApiService.fetchCategories(_authToken!);
      DataService.updateCategoryMapping(categories);
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat kategori: $e')));
      }
    }
  }

  Future<void> _fetchAnnouncements() async {
    if (_authToken == null) return;
    setState(() => _isLoading = true);
    try {
      final announcements = await ApiService.fetchAnnouncements(_authToken!);
      setState(() {
        _allAnnouncements = announcements;
        _filteredAnnouncements = List.from(_allAnnouncements);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat pengumuman: $e')));
      }
    }
  }

  void _filterAnnouncements() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAnnouncements =
          _allAnnouncements.where((announcement) {
            final matchesCategory =
                _selectedCategory == null ||
                announcement.tag == _selectedCategory;
            final matchesQuery =
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
      _selectedCategory =
          _selectedCategory == categoryName ? null : categoryName;
      _filterAnnouncements();
    });
  }

  void _showAnnouncementDetail(Announcement announcement) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                HomeStyles.borderRadiusXXLarge,
              ),
            ),
            child: AnnouncementDetailPopup(announcement: announcement),
          ),
    );
  }

  Future<void> _handleLogout() async {
    final success = await AuthService.logout();
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInPage()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal logout, coba lagi.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth * 0.08;
    return MainLayout(
      selectedIndex: 0,
      child: Container(
        color: HomeStyles.white,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await _fetchCategories();
              await _fetchAnnouncements();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: HomeStyles.paddingXXLarge,
              ),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    horizontalPadding: horizontalPadding,
                    userName: _userName,
                    onLogout: _handleLogout,
                  ),
                  const SizedBox(height: HomeStyles.spacingXXXLarge),
                  SearchBarWidget(
                    controller: _searchController,
                    horizontalPadding: horizontalPadding,
                  ),
                  const SizedBox(height: HomeStyles.spacingXXXXXLarge),
                  BannerSectionWidget(
                    banners: DataService.banners,
                    controller: _bannerController,
                    currentIndex: _currentBannerIndex,
                    horizontalPadding: horizontalPadding,
                    onPageChanged:
                        (index) => setState(() => _currentBannerIndex = index),
                  ),
                  const SizedBox(height: HomeStyles.spacingXXXXXXLarge),
                  CategorySectionWidget(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    horizontalPadding: horizontalPadding,
                    onCategorySelected: _selectCategory,
                    showTooltip: _showCategoryTooltip,
                  ),
                  const SizedBox(height: HomeStyles.spacingXXXXXXLarge),
                  AnnouncementsSectionWidget(
                    announcements: _filteredAnnouncements,
                    isLoading: _isLoading,
                    selectedCategory: _selectedCategory,
                    horizontalPadding: horizontalPadding,
                    onAnnouncementTap: _showAnnouncementDetail,
                  ),
                  const SizedBox(height: HomeStyles.spacingXXXXXLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final double horizontalPadding;
  final String? userName;
  final VoidCallback onLogout;

  const HeaderWidget({
    super.key,
    required this.horizontalPadding,
    required this.userName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hallo, ${userName ?? 'User'}!',
                  style: HomeStyles.welcome,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  DateService.formatDate(DateTime.now()),
                  style: HomeStyles.date,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final double horizontalPadding;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        height: HomeStyles.searchBarHeight,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 208, 208, 208),
          borderRadius: BorderRadius.circular(HomeStyles.borderRadiusXXXLarge),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 40, 40, 40).withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Cari pengumuman...',
            hintStyle: HomeStyles.searchHint.copyWith(
              color: Color.fromARGB(255, 104, 104, 104),
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Color.fromARGB(255, 104, 104, 104),
              size: HomeStyles.iconSizeLarge,
            ),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder:
                  (_, value, __) =>
                      value.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: HomeStyles.iconSizeMedium,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            onPressed: controller.clear,
                          )
                          : const SizedBox.shrink(),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                HomeStyles.borderRadiusXXXLarge,
              ),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            contentPadding: const EdgeInsets.symmetric(
              vertical: HomeStyles.paddingXLarge,
            ),
          ),
        ),
      ),
    );
  }
}

class BannerSectionWidget extends StatelessWidget {
  final List<EventBanner> banners;
  final PageController controller;
  final int currentIndex;
  final double horizontalPadding;
  final Function(int) onPageChanged;

  const BannerSectionWidget({
    super.key,
    required this.banners,
    required this.controller,
    required this.currentIndex,
    required this.horizontalPadding,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text('Acara yang Akan Datang', style: HomeStyles.sectionTitle),
        ),
        const SizedBox(height: HomeStyles.spacingXXLarge),
        SizedBox(
          height: HomeStyles.bannerHeight,
          child: PageView.builder(
            controller: controller,
            itemCount: banners.length,
            onPageChanged: onPageChanged,
            itemBuilder:
                (context, index) => BannerItemWidget(
                  banner: banners[index],
                  horizontalPadding: horizontalPadding,
                ),
          ),
        ),
        const SizedBox(height: HomeStyles.spacingXXLarge),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => PageIndicatorWidget(isActive: index == currentIndex),
            ),
          ),
        ),
      ],
    );
  }
}

class BannerItemWidget extends StatelessWidget {
  final EventBanner banner;
  final double horizontalPadding;

  const BannerItemWidget({
    super.key,
    required this.banner,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HomeStyles.borderRadiusXLarge),
        image: DecorationImage(
          image: AssetImage(banner.imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: HomeStyles.shadow.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HomeStyles.borderRadiusXLarge),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [HomeStyles.shadow.withOpacity(0.8), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(HomeStyles.paddingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: HomeStyles.paddingMedium,
                vertical: HomeStyles.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: banner.tagColor,
                borderRadius: BorderRadius.circular(
                  HomeStyles.borderRadiusMedium,
                ),
              ),
              child: Text(banner.tag, style: HomeStyles.bannerTag),
            ),
            const SizedBox(height: HomeStyles.spacingXLarge),
            Text(
              banner.title,
              style: HomeStyles.bannerTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: HomeStyles.spacingMedium),
            Text(banner.subtitle, style: HomeStyles.bannerSubtitle),
          ],
        ),
      ),
    );
  }
}

class PageIndicatorWidget extends StatelessWidget {
  final bool isActive;
  const PageIndicatorWidget({super.key, required this.isActive});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: HomeStyles.paddingSmall),
      height: HomeStyles.indicatorHeight,
      width:
          isActive
              ? HomeStyles.indicatorWidthActive
              : HomeStyles.indicatorWidthInactive,
      decoration: BoxDecoration(
        color:
            isActive ? HomeStyles.blue : HomeStyles.textGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(HomeStyles.borderRadiusSmall),
      ),
    );
  }
}

class CategorySectionWidget extends StatelessWidget {
  final List<CategoryData> categories;
  final String? selectedCategory;
  final double horizontalPadding;
  final Function(String) onCategorySelected;
  final bool showTooltip;

  const CategorySectionWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.horizontalPadding,
    required this.onCategorySelected,
    required this.showTooltip,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kategori', style: HomeStyles.sectionTitle),
                  if (selectedCategory != null)
                    ClearFilterButtonWidget(
                      onPressed: () => onCategorySelected(selectedCategory!),
                    ),
                ],
              ),
              if (showTooltip && categories.isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  top:
                      HomeStyles.categoryHeight +
                      HomeStyles.spacingXXXLarge +
                      7,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: HomeStyles.paddingMedium,
                        vertical: HomeStyles.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                          HomeStyles.borderRadiusMedium,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                     child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.info_outline,
          color: HomeStyles.white,
          size: HomeStyles.iconSizeSmall,
        ),
        const SizedBox(width: HomeStyles.spacingSmall),
        Text(
          'Tekan lama ikon untuk melihat ',
          style: HomeStyles.tooltipText,
        ),
      ],
    ),
    Text(
      'penjelasan kategori',
      style: HomeStyles.tooltipText,
    ),
  ],
),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: HomeStyles.spacingXXXLarge),
        SizedBox(
          height: HomeStyles.categoryHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: categories.length,
            separatorBuilder:
                (context, index) =>
                    const SizedBox(width: HomeStyles.spacingXXXXLarge),
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

class ClearFilterButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const ClearFilterButtonWidget({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        Icons.close,
        size: HomeStyles.iconSizeSmall,
        color: HomeStyles.textGrey[800],
      ),
      label: Text('Hapus filter', style: HomeStyles.clearFilter),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: HomeStyles.paddingLarge,
          vertical: HomeStyles.paddingMedium,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class CategoryItemWidget extends StatelessWidget {
  final CategoryData category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItemWidget({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        HapticFeedback.mediumImpact();
        CategoryTapHandler.showCategoryDescription(context, category);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: HomeStyles.categoryCircleSize,
            height: HomeStyles.categoryCircleSize,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
              border:
                  isSelected
                      ? Border.all(
                        color: Colors.black,
                        width: HomeStyles.borderWidth,
                      )
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
                      : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    category.icon,
                    color: HomeStyles.white,
                    size: HomeStyles.iconSizeXLarge,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: HomeStyles.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: HomeStyles.spacingXLarge),
          SizedBox(
            width: 90,
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    category.name,
                    style:
                        isSelected
                            ? HomeStyles.categoryNameSelected
                            : HomeStyles.categoryName,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(
                      top: HomeStyles.spacingMedium,
                    ),
                    width: HomeStyles.iconSizeSmall,
                    height: HomeStyles.spacingSmall,
                    decoration: BoxDecoration(
                      color: category.color,
                      borderRadius: BorderRadius.circular(
                        HomeStyles.borderRadiusSmall,
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

class AnnouncementsSectionWidget extends StatelessWidget {
  final List<Announcement> announcements;
  final bool isLoading;
  final String? selectedCategory;
  final double horizontalPadding;
  final Function(Announcement) onAnnouncementTap;

  const AnnouncementsSectionWidget({
    super.key,
    required this.announcements,
    required this.isLoading,
    required this.selectedCategory,
    required this.horizontalPadding,
    required this.onAnnouncementTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnnouncementsHeaderWidget(
          horizontalPadding: horizontalPadding,
          selectedCategory: selectedCategory,
        ),
        const SizedBox(height: HomeStyles.spacingXXXLarge),
        AnnouncementsListWidget(
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

class AnnouncementsHeaderWidget extends StatelessWidget {
  final double horizontalPadding;
  final String? selectedCategory;

  const AnnouncementsHeaderWidget({
    super.key,
    required this.horizontalPadding,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pengumuman Terbaru', style: HomeStyles.sectionTitle),
          if (selectedCategory != null)
            Padding(
              padding: const EdgeInsets.only(top: HomeStyles.spacingMedium),
              child: Row(
                children: [
                  Text(
                    'Difilter berdasarkan:  ',
                    style: HomeStyles.filterLabel,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: HomeStyles.paddingMedium,
                      vertical: HomeStyles.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: DataService.getCategoryColor(selectedCategory!),
                      borderRadius: BorderRadius.circular(
                        HomeStyles.borderRadiusMedium,
                      ),
                    ),
                    child: Text(selectedCategory!, style: HomeStyles.filterTag),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AnnouncementsListWidget extends StatelessWidget {
  final List<Announcement> announcements;
  final bool isLoading;
  final String? selectedCategory;
  final double horizontalPadding;
  final Function(Announcement) onAnnouncementTap;

  const AnnouncementsListWidget({
    super.key,
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
          vertical: HomeStyles.paddingXXXXLarge,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (announcements.isEmpty) {
      return EmptyStateWidget(
        horizontalPadding: horizontalPadding,
        selectedCategory: selectedCategory,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: announcements.length,
      separatorBuilder:
          (context, index) =>
              const SizedBox(height: HomeStyles.spacingXXXLarge),
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

class EmptyStateWidget extends StatelessWidget {
  final double horizontalPadding;
  final String? selectedCategory;

  const EmptyStateWidget({
    super.key,
    required this.horizontalPadding,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: HomeStyles.paddingXXXXXLarge,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.announcement_outlined,
              size: HomeStyles.iconSizeXXLarge,
              color: HomeStyles.textGrey[400],
            ),
            const SizedBox(height: HomeStyles.spacingXXXLarge),
            Text(
              selectedCategory != null
                  ? 'Tidak ditemukan pengumuman untuk "$selectedCategory"'
                  : 'Tidak ada pengumuman tersedia',
              style: HomeStyles.emptyTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HomeStyles.spacingXLarge),
            Text(
              selectedCategory != null
                  ? 'Coba pilih kategori lain atau hapus filter.'
                  : 'Cek kembali nanti untuk pengumuman baru.',
              style: HomeStyles.emptySubtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementCardWidget extends StatelessWidget {
  final Announcement announcement;
  final double horizontalPadding;
  final VoidCallback onTap;

  const AnnouncementCardWidget({
    super.key,
    required this.announcement,
    required this.horizontalPadding,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUrgent =
        announcement.tag.toLowerCase() == 'urgent' ||
        announcement.tag.toLowerCase() == 'penting';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
        padding: const EdgeInsets.all(HomeStyles.paddingXLarge),
        decoration: BoxDecoration(
          color: HomeStyles.white,
          borderRadius: BorderRadius.circular(HomeStyles.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: HomeStyles.textGrey.withOpacity(0.1),
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
                    horizontal: HomeStyles.paddingMedium,
                    vertical: HomeStyles.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: announcement.tagColor,
                    borderRadius: BorderRadius.circular(
                      HomeStyles.borderRadiusSmall,
                    ),
                  ),
                  child: Text(
                    announcement.tag,
                    style: HomeStyles.announcementTag,
                  ),
                ),
                const Spacer(),
                Text(announcement.timeAgo, style: HomeStyles.announcementTime),
              ],
            ),
            const SizedBox(height: HomeStyles.spacingXXLarge),
            Text(
              announcement.title,
              style: HomeStyles.announcementTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: HomeStyles.spacingXLarge),
            Text(
              announcement.description,
              style: HomeStyles.announcementDescription,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (isUrgent) ...[
              const SizedBox(height: HomeStyles.spacingXXLarge),
              Row(
                children: [
                  Icon(
                    Icons.priority_high,
                    size: HomeStyles.iconSizeSmall,
                    color: HomeStyles.red,
                  ),
                  const SizedBox(width: HomeStyles.spacingMedium),
                  Text('Penting', style: HomeStyles.urgentLabel),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

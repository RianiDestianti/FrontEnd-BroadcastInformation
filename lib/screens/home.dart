import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../layouts/layout.dart';
import '../models/announcement.dart';
import 'popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller for search field
  final TextEditingController _searchController = TextEditingController();

  // Selected category filter
  String? _selectedCategory;

  // List of all announcements
  final List<Announcement> _allAnnouncements = [
    Announcement(
      id: '1',
      tag: 'Academic',
      tagColor: const Color(0xFF9db7e0),
      timeAgo: '2h Ago',
      title: 'Jam Perpustakaan Diperpanjang Selama Ujian Akhir',
      description:
          'Perpustakaan utama akan memperpanjang jam operasionalnya dari pukul 8 pagi hingga pukul 2 pagi mulai tanggal 10 Mei hingga akhir...',
      fullContent: '''
📍 Lokasi: Perpustakaan Utama
📅 Periode Berlaku: Mulai 10 Mei hingga akhir bulan Mei 2025
🕗 Jam Operasional Baru:
08.00 pagi - 02.00 dini hari (setiap hari)

⚡Keterangan Tambahan:
• Perpanjangan jam ini bertujuan untuk memberikan waktu lebih luas bagi mahasiswa dan pengunjung dalam mengakses layanan perpustakaan, terutama menjelang masa ujian.
• Seluruh fasilitas seperti ruang baca, komputer umum, dan layanan peminjaman tetap tersedia selama jam operasional baru.
• Harap tetap menjaga ketertiban dan kebersihan selama menggunakan fasilitas perpustakaan.

📌 Catatan Penting:
• Layanan peminjaman dan pengembalian buku terakhir dibuka hingga pukul 22.00 WIB
• Area perpustakaan akan ditutup tepat pukul 02.00 WIB
• Pengunjung wajib menunjukkan kartu anggota perpustakaan atau identitas kampus saat masuk di jam malam

Tetap semangat belajar, manfaatkan waktu dengan bijak!
Untuk informasi lebih lanjut, hubungi petugas perpustakaan
      ''',
      department: 'Dari: Layanan Perpustakaan',
    ),
    Announcement(
      id: '2',
      tag: 'Events',
      tagColor: const Color(0xFFdfed90),
      timeAgo: '1h Ago',
      title: 'Guest Speaker: Kak Adit Santoso',
      description:
          'Bergabunglah bersama kami untuk bincang inspiratif bersama Kak Adit Santoso, alumni SMK RSI 2018 dan juara nasional IKS bidang IT Software Solutions, dalam acara "Next Step: Menjadi Developer Profes..."',
      fullContent: '''
🎤 Guest Speaker Series: Alumni Success Stories

📌 Speaker: Kak Adit Santoso
🏆 Alumni SMK RSI 2018, Juara Nasional IKS bidang IT Software Solutions
💼 Current: Senior Developer at Google Indonesia

📆 Tanggal: 15 Mei 2025
⏰ Waktu: 14.00 - 16.00 WIB
📍 Lokasi: Auditorium Utama

🔍 Topik: "Next Step: Menjadi Developer Profesional di Era AI"

Kak Adit akan berbagi:
• Perjalanan karir setelah lulus SMK
• Tips memenangkan kompetisi nasional
• Strategi mendapatkan pekerjaan di perusahaan teknologi top
• Keterampilan yang paling dicari di industri saat ini
• Q&A Session

✅ Pendaftaran:
Scan QR code di poster atau kunjungi link pendaftaran di bio Instagram @smkrisiofficial

Jangan lewatkan kesempatan belajar dari alumni sukses kita!
      ''',
      department: 'Dari: Kurikulum',
    ),
    Announcement(
      id: '3',
      tag: 'News',
      tagColor: const Color(0xFF1665a5),
      timeAgo: '2h Ago',
      title: 'Update Fasilitas Kampus',
      description:
          'Beberapa area kampus akan mengalami renovasi mulai minggu depan. Perkuliahan akan tetap berjalan seperti biasa dengan beberapa penyesuaian ruangan...',
      fullContent: '''
📢 PENGUMUMAN RENOVASI FASILITAS KAMPUS

Dalam upaya meningkatkan kualitas fasilitas pendidikan, beberapa area kampus akan mengalami renovasi:

📆 Jadwal Renovasi: 20 Mei - 20 Juni 2025

🚧 Area yang Direnovasi:
• Laboratorium Komputer Lantai 2
• Kantin Utama
• Toilet di Gedung A lantai 1
• Area Parkir Selatan

⚠️ Penyesuaian:
• Kelas yang biasanya menggunakan Lab Komputer Lt.2 akan dipindahkan ke Lab Komputer Cadangan di Gedung B
• Kantin sementara akan beroperasi di Aula Terbuka
• Toilet sementara telah disediakan di sebelah ruang administrasi
• Kendaraan dapat diparkir di area parkir timur dan barat

✅ Perkuliahan tetap berjalan seperti biasa dengan penyesuaian lokasi.
✅ Peta lokasi sementara dapat diakses melalui aplikasi kampus.

Mohon maaf atas ketidaknyamanan yang mungkin terjadi. Renovasi ini bertujuan untuk meningkatkan kenyamanan dan kualitas fasilitas untuk kita semua.

Terima kasih atas pengertian dan kerjasamanya.
      ''',
      department: 'Dari: Bagian Umum',
    ),
    // Added more announcements for each category for testing
    Announcement(
      id: '4',
      tag: 'Announcements',
      tagColor: const Color(0xFFf08e79),
      timeAgo: '3h Ago',
      title: 'Pengumuman Pembayaran UKT Semester Genap',
      description:
          'Pembayaran UKT semester genap 2024/2025 akan dimulai tanggal 1 Juni. Pastikan melakukan pembayaran tepat waktu untuk menghindari denda...',
      fullContent: '''
📢 INFORMASI PEMBAYARAN UKT SEMESTER GENAP 2024/2025

📆 Jadwal Pembayaran: 1 Juni - 15 Juni 2025

💰 Metode Pembayaran:
• Transfer Bank melalui Virtual Account
• Pembayaran melalui aplikasi perbankan
• Pembayaran langsung di Bank BNI/BRI/Mandiri

⚠️ Informasi Penting:
• Denda keterlambatan akan dikenakan mulai 16 Juni 2025
• Mahasiswa yang belum melunasi tidak dapat mengikuti perkuliahan semester genap
• Konfirmasi pembayaran dapat dilakukan melalui sistem akademik

Untuk informasi lebih lanjut, silakan menghubungi Bagian Keuangan.
      ''',
      department: 'Dari: Bagian Keuangan',
    ),
    Announcement(
      id: '5',
      tag: 'Academic',
      tagColor: const Color(0xFF9db7e0),
      timeAgo: '5h Ago',
      title: 'Jadwal Ujian Akhir Semester',
      description:
          'Jadwal ujian akhir semester telah dirilis. Semua mahasiswa diharapkan memeriksa jadwal ujian dan mempersiapkan diri dengan baik...',
      fullContent: '''
📝 JADWAL UJIAN AKHIR SEMESTER GANJIL 2024/2025

📆 Periode Ujian: 25 Mei - 5 Juni 2025

⚠️ Informasi Penting:
• Jadwal lengkap tersedia di sistem akademik
• Bawa kartu ujian dan kartu identitas mahasiswa
• Hadir 30 menit sebelum ujian dimulai
• Pakaian rapi dan sepatu tertutup

📌 Ketentuan Ujian:
• Tidak diperkenankan membawa contekan dalam bentuk apapun
• Ponsel harus dimatikan dan dimasukkan ke dalam tas
• Tidak diizinkan berbicara selama ujian berlangsung
• Keterlambatan lebih dari 30 menit tidak diperbolehkan masuk

Untuk pertanyaan, silakan hubungi Bagian Akademik.
      ''',
      department: 'Dari: Bagian Akademik',
    ),
    Announcement(
      id: '6',
      tag: 'Events',
      tagColor: const Color(0xFFdfed90),
      timeAgo: '1d Ago',
      title: 'Workshop UI/UX Design',
      description:
          'Ikuti workshop UI/UX Design bersama praktisi industri pada tanggal 18 Mei 2025. Pendaftaran dibuka mulai hari ini...',
      fullContent: '''
🎨 WORKSHOP UI/UX DESIGN

📌 Pembicara: Budi Hartono, Senior UI/UX Designer at Tokopedia

📆 Tanggal: 18 Mei 2025
⏰ Waktu: 09.00 - 15.00 WIB
📍 Lokasi: Ruang Multimedia

🔍 Materi Workshop:
• Dasar-dasar UI/UX Design
• User Research & User Persona
• Wireframing & Prototyping
• Design System
• Portfolio Building

✅ Fasilitas:
• Sertifikat
• Makan siang
• Merchandise
• Kesempatan magang

Biaya Pendaftaran: Rp150.000
Kapasitas terbatas untuk 50 peserta!

Daftar sekarang melalui link: bit.ly/workshopuxui2025
      ''',
      department: 'Dari: Himpunan Mahasiswa Informatika',
    ),
  ];

  // Filtered announcements based on search and category
  List<Announcement> _filteredAnnouncements = [];

  // List of available categories
  final List<CategoryData> _categories = [
    CategoryData(
      name: 'Announcements',
      color: const Color(0xFFf08e79),
      icon: Icons.campaign,
    ),
    CategoryData(
      name: 'Academic',
      color: const Color(0xFF9db7e0),
      icon: Icons.school,
    ),
    CategoryData(
      name: 'Events',
      color: const Color(0xFFdfed90),
      icon: Icons.event,
    ),
    CategoryData(
      name: 'News',
      color: const Color(0xFF1665a5),
      icon: Icons.newspaper,
    ),
    CategoryData(name: 'Articles', color: Colors.purple, icon: Icons.article),
    CategoryData(
      name: 'Calendar',
      color: Colors.teal,
      icon: Icons.calendar_today,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all announcements
    _filteredAnnouncements = List.from(_allAnnouncements);

    // Add listener to search controller
    _searchController.addListener(_filterAnnouncements);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter announcements based on search text and selected category
  void _filterAnnouncements() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredAnnouncements =
          _allAnnouncements.where((announcement) {
            // First check if it matches category filter (if any)
            bool matchesCategory =
                _selectedCategory == null ||
                announcement.tag == _selectedCategory;

            // Then check if it matches search query (if any)
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

  // Handle category selection
  void _selectCategory(String categoryName) {
    setState(() {
      // If the same category is tapped again, clear the filter
      if (_selectedCategory == categoryName) {
        _selectedCategory = null;
      } else {
        _selectedCategory = categoryName;
      }

      // Update filtered list
      _filterAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for better padding calculation
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding =
        screenWidth * 0.08; // Increased from 0.05 to 0.08 for more padding

    return MainLayout(
      selectedIndex: 0, // 0 for home page
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
          ), // Increased vertical padding
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              _buildSearchBar(horizontalPadding),

              const SizedBox(height: 24), // Increased spacing
              // Categories Section with Clear Filter option if category is selected
              _buildCategorySectionHeader(horizontalPadding),

              const SizedBox(height: 16), // Increased spacing
              // Categories Icons - Scrollable
              _buildCategoriesScrollView(horizontalPadding),

              const SizedBox(height: 30), // Increased spacing
              // Recent Announcements Header with category filter indicator
              _buildAnnouncementsHeader(horizontalPadding),

              const SizedBox(height: 16),

              // Display filtered announcements
              if (_filteredAnnouncements.isEmpty)
                _buildEmptyState(horizontalPadding)
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredAnnouncements.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final announcement = _filteredAnnouncements[index];
                    return _buildAnnouncementCard(
                      context: context,
                      announcement: announcement,
                      horizontalPadding: horizontalPadding,
                      onTap:
                          () => _showAnnouncementDetail(context, announcement),
                    );
                  },
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Empty state widget
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

  // Search Bar Widget with improved styling
  Widget _buildSearchBar(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        height: 52, // Increased height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26), // Increased radius
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
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  // Categories Section Header with Clear Filter option
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
          if (_selectedCategory != null)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedCategory = null;
                  _filterAnnouncements();
                });
              },
              icon: Icon(Icons.close, size: 16, color: Colors.blue[800]),
              label: Text(
                'Clear filter',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }

  // Announcements Header with category indicator
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
          if (_selectedCategory != null)
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
                      color: _getCategoryColor(_selectedCategory!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedCategory!,
                      style: GoogleFonts.poppins(
                        color:
                            _selectedCategory == 'News'
                                ? Colors.white
                                : Colors.black87,
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

  // Categories Scrollable Widget with selection functionality
  Widget _buildCategoriesScrollView(double horizontalPadding) {
    return SizedBox(
      height: 110, // Slightly increased height
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final bool isSelected = _selectedCategory == category.name;

          return CategoryItem(
            color: category.color,
            icon: category.icon,
            label: category.name,
            isSelected: isSelected,
            onTap: () => _selectCategory(category.name),
          );
        },
      ),
    );
  }

  // Announcement Card Widget - Updated with improved styling
  Widget _buildAnnouncementCard({
    required BuildContext context,
    required Announcement announcement,
    required double horizontalPadding,
    required VoidCallback onTap,
  }) {
    final bool isDarkTag =
        announcement.tag == 'News'; // For text color on dark backgrounds

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: announcement.tagColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            announcement.tag,
                            style: GoogleFonts.poppins(
                              color: isDarkTag ? Colors.white : Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          announcement.timeAgo,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.bookmark_border,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
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

  // Show announcement detail in a popup modal
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
}

// Category Data model for organization
class CategoryData {
  final String name;
  final Color color;
  final IconData icon;

  CategoryData({required this.name, required this.color, required this.icon});
}

// Extract Category Item to a separate widget with selection functionality
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
          // Container with selection indicator
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border:
                  isSelected
                      ? Border.all(color: Colors.black, width: 2.5)
                      : null,
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
          ),
          const SizedBox(height: 8),
          // Label with selection indicator
          SizedBox(
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
          ),
        ],
      ),
    );
  }
}

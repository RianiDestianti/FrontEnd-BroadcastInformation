// File: screens/home.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../layouts/layout.dart'; // Sesuaikan path import

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final themeColor = Color(0xFF57B4BA);
    
    return MainLayout(
      selectedIndex: 0, // 0 untuk home page
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              Text(
                'Selamat Datang',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Apa yang ingin Anda lakukan hari ini?',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              
              // Konten utama
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contoh card informasi
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: themeColor.withOpacity(0.3))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Info Terkini',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Selamat datang di aplikasi kami! Silakan jelajahi berbagai fitur yang tersedia.',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Judul menu
                      Text(
                        'Menu',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Grid menu
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        children: [
                          _buildMenuCard(
                            icon: Icons.article_outlined,
                            title: 'Artikel',
                            color: themeColor,
                            onTap: () {
                              // Navigasi ke halaman artikel
                              Navigator.pushNamed(context, '/articles');
                            },
                          ),
                          _buildMenuCard(
                            icon: Icons.notifications_outlined,
                            title: 'Notifikasi',
                            color: Colors.orange,
                            onTap: () {
                              // Navigasi ke halaman notifikasi
                              Navigator.pushNamed(context, '/notifications');
                            },
                          ),
                          _buildMenuCard(
                            icon: Icons.calendar_today_outlined,
                            title: 'Jadwal',
                            color: Colors.purple,
                            onTap: () {
                              // Navigasi ke halaman jadwal
                              Navigator.pushNamed(context, '/schedule');
                            },
                          ),
                          _buildMenuCard(
                            icon: Icons.help_outline,
                            title: 'Bantuan',
                            color: Colors.green,
                            onTap: () {
                              // Navigasi ke halaman bantuan
                              Navigator.pushNamed(context, '/help');
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Aktivitas terbaru
                      Text(
                        'Aktivitas Terbaru',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // List aktivitas
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: themeColor.withOpacity(0.2),
                              child: Icon(
                                index == 0 ? Icons.check_circle_outline :
                                index == 1 ? Icons.access_time : Icons.star_outline,
                                color: themeColor,
                              ),
                            ),
                            title: Text(
                              index == 0 ? 'Tugas Selesai' :
                              index == 1 ? 'Pengingat' : 'Artikel Baru',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              index == 0 ? 'Selesai kemarin' :
                              index == 1 ? 'Besok pukul 10:00' : 'Ditambahkan hari ini',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
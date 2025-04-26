// File: screens/profile.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../layouts/layout.dart';
import 'login.dart'; // Import halaman login

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(0xFF57B4BA);
    
    return MainLayout(
      selectedIndex: 2, // 2 untuk profile page
      child: SafeArea(
        child: Column(
          children: [
            // Header dengan tombol back
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            
            // Profile picture
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.pink[100],
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.purple[300],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Nama pengguna
            Text(
              'Elara Zafira',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // Subtitle
            Text(
              '• Rekayasa Perangkat Lunak',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Card informasi personal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Information',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Divider(),
                      _buildInfoRow('Full Name', 'Elara Zafira'),
                      _buildInfoRow('Student ID', '093264'),
                      _buildInfoRow('Role', 'Siswa'),
                      _buildInfoRow('Email', 'laraza@gmail.com'),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Change password button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Logika untuk ganti password
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: Colors.green,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Change Password',
                            style: GoogleFonts.poppins(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Navigasi ke halaman login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
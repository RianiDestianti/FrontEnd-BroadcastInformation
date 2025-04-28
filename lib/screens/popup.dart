import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/announcement.dart';

// Announcement Detail Popup Widget
class AnnouncementDetailPopup extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetailPopup({Key? key, required this.announcement})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkTag = announcement.tag == 'News';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      child: Stack(
        children: [
          // Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: announcement.tagColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      announcement.tag,
                      style: GoogleFonts.poppins(
                        color: isDarkTag ? Colors.white : Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    announcement.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Divider(),
                  const SizedBox(height: 10),
                  // Full content
                  Text(
                    announcement.fullContent,
                    style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(
                    height: 30,
                  ), // Space at bottom to ensure content isn't hidden behind home icon
                ],
              ),
            ),
          ),
          // Close button at top-right
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Home button at bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
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
          ),
        ],
      ),
    );
  }
}
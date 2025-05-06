import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/announcement.dart';

class AnnouncementDetailPopup extends StatelessWidget {
  final Announcement announcement;
  static const double _padding = 20.0;
  static const double _tagPaddingHorizontal = 12.0;
  static const double _tagPaddingVertical = 6.0;
  static const double _tagBorderRadius = 16.0;
  static const double _spacingSmall = 6.0;
  static const double _spacingMedium = 10.0;
  static const double _spacingLarge = 16.0;
  static const double _spacingExtraLarge = 30.0;

  const AnnouncementDetailPopup({
    Key? key, 
    required this.announcement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: _buildContainerConstraints(context),
      child: Stack(
        children: [
          _buildAnnouncementContent(),
          _buildCloseButton(context),
        ],
      ),
    );
  }

  BoxConstraints _buildContainerConstraints(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return BoxConstraints(
      maxHeight: screenSize.height * 0.8,
      maxWidth: screenSize.width * 0.9,
    );
  }

  Widget _buildAnnouncementContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTagLabel(),
            const SizedBox(height: _spacingLarge),
            _buildTitle(),
            const SizedBox(height: _spacingSmall),
            const Divider(),
            const SizedBox(height: _spacingMedium),
            _buildFullContent(),
            const SizedBox(height: _spacingExtraLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildTagLabel() {
    final bool isDarkTag = announcement.tag == 'News';
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _tagPaddingHorizontal,
        vertical: _tagPaddingVertical,
      ),
      decoration: BoxDecoration(
        color: announcement.tagColor,
        borderRadius: BorderRadius.circular(_tagBorderRadius),
      ),
      child: Text(
        announcement.tag,
        style: GoogleFonts.poppins(
          color: isDarkTag ? Colors.white : Colors.black87,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      announcement.title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFullContent() {
    return Text(
      announcement.fullContent,
      style: GoogleFonts.poppins(
        fontSize: 14, 
        height: 1.5,
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
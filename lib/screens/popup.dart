import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/model.dart';

class AnnouncementDetailPopup extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementDetailPopup({Key? key, required this.announcement})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenSize.height * 0.8,
        maxWidth: screenSize.width * 0.9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(children: [_buildContent(), _buildCloseButton(context)]),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTag(),
            const SizedBox(height: 12),
            _buildHeaderImage(),
            const SizedBox(height: 16),
            _buildTitle(),
            const SizedBox(height: 6),
            const Divider(),
            const SizedBox(height: 10),
            _buildFormattedContent(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: announcement.tagColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        announcement.tag,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 150.0,
        child: Image.asset('assets/akl.jpg', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      announcement.title,
      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFormattedContent() {
    return ContentParser(content: announcement.fullContent);
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.close, size: 18, color: Colors.black54),
        ),
      ),
    );
  }
}

class ContentParser extends StatelessWidget {
  final String content;
  const ContentParser({Key? key, required this.content}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final contentWidgets = <Widget>[];

    for (final line in lines) {
      if (line.trim().isEmpty) {
        contentWidgets.add(const SizedBox(height: 8));
        continue;
      }
      contentWidgets.add(_parseContentLine(line));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentWidgets,
    );
  }

  Widget _parseContentLine(String line) {
    final patterns = <String, Widget Function(String)>{
      '📍 Lokasi:':
          (text) => _buildInfoRow(
            Icons.location_on,
            text.replaceFirst('📍 Lokasi:', '').trim(),
          ),
      '📅 Periode Berlaku:':
          (text) => _buildInfoRow(
            Icons.calendar_today,
            text.replaceFirst('📅 Periode Berlaku:', '').trim(),
          ),
      '🕗 Jam Operasional Baru:':
          (text) => _buildInfoRow(
            Icons.access_time,
            text.replaceFirst('🕗 Jam Operasional Baru:', '').trim(),
          ),
      '⚡Keterangan Tambahan:':
          (_) => _buildSectionTitle('Keterangan Tambahan:'),
      '📌 Catatan Penting:': (_) => _buildSectionTitle('Catatan Penting:'),
      '• ': (text) => _buildBulletPoint(text.replaceFirst('• ', '').trim()),
    };

    for (final pattern in patterns.keys) {
      if (line.startsWith(pattern)) {
        return patterns[pattern]!(line);
      }
    }

    if (line.contains('Tetap semangat belajar')) {
      return _buildConclusionText(line);
    }

    return _buildDefaultText(line);
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: _getTextStyle())),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: _getTextStyle())),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildConclusionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontStyle: FontStyle.italic, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDefaultText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text, style: _getTextStyle()),
    );
  }

  TextStyle _getTextStyle() {
    return GoogleFonts.poppins(fontSize: 14, height: 1.5);
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/model.dart';

class AnnouncementDetailPopup extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementDetailPopup({Key? key, required this.announcement})
    : super(key: key);

  @override
 Widget build(BuildContext context) {
  return PopupContainer(
    color: Colors.white, 
    child: Stack(
      children: [
        AnnouncementContent(announcement: announcement),
        CloseButtonWidget(),
      ],
    ),
  );
}

}

class PopupContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  const PopupContainer({
    Key? key,
    required this.child,
    this.color = Colors.white, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(
        maxHeight: screenSize.height * 0.8,
        maxWidth: screenSize.width * 0.9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

class AnnouncementContent extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementContent({Key? key, required this.announcement})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TagLabel(announcement: announcement),
            const SizedBox(height: 12),
            HeaderImage(),
            const SizedBox(height: 16),
            TitleWidget(title: announcement.title),
            const SizedBox(height: 6),
            const Divider(),
            const SizedBox(height: 10),
            FormattedContent(content: announcement.fullContent),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class TagLabel extends StatelessWidget {
  final Announcement announcement;
  const TagLabel({Key? key, required this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkTag = announcement.tag == 'News';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: announcement.tagColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        announcement.tag,
        style: GoogleFonts.poppins(
          color: Colors.white, // Selalu putih
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class HeaderImage extends StatelessWidget {
  const HeaderImage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 150.0,
        child: Image.asset('assets/akl.jpg', fit: BoxFit.cover),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String title;
  const TitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class FormattedContent extends StatelessWidget {
  final String content;
  const FormattedContent({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentParser(content: content);
  }
}

class ContentParser extends StatelessWidget {
  final String content;
  const ContentParser({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    List<Widget> contentWidgets = [];

    for (String line in lines) {
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
    if (line.startsWith('📍 Lokasi:')) {
      return InfoRow(
        icon: Icons.location_on,
        text: line.replaceFirst('📍 Lokasi:', '').trim(),
      );
    }

    if (line.startsWith('📅 Periode Berlaku:')) {
      return InfoRow(
        icon: Icons.calendar_today,
        text: line.replaceFirst('📅 Periode Berlaku:', '').trim(),
      );
    }

    if (line.startsWith('🕗 Jam Operasional Baru:')) {
      return InfoRow(
        icon: Icons.access_time,
        text: line.replaceFirst('🕗 Jam Operasional Baru:', '').trim(),
      );
    }

    if (line.startsWith('⚡Keterangan Tambahan:')) {
      return SectionTitle(title: 'Keterangan Tambahan:');
    }

    if (line.startsWith('• ')) {
      return BulletPoint(text: line.replaceFirst('• ', '').trim());
    }

    if (line.startsWith('📌 Catatan Penting:')) {
      return SectionTitle(title: 'Catatan Penting:');
    }

    if (line.contains('Tetap semangat belajar')) {
      return ConclusionText(text: line);
    }

    return DefaultText(text: line);
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoRow({Key? key, required this.icon, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}

class ConclusionText extends StatelessWidget {
  final String text;
  const ConclusionText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontStyle: FontStyle.italic, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class DefaultText extends StatelessWidget {
  final String text;
  const DefaultText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 14, height: 1.5)),
    );
  }
}

class CloseButtonWidget extends StatelessWidget {
  const CloseButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, size: 20),
        ),
      ),
    );
  }
}

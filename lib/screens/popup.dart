import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/model.dart';
import '../constants/constant.dart';

class AnnouncementDetailPopup extends StatelessWidget {
  const AnnouncementDetailPopup({super.key, required this.announcement});
  final Announcement announcement;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: screenSize.height * PopupStyles.maxHeightFactor,
        maxWidth: screenSize.width * PopupStyles.maxWidthFactor,
      ),
      decoration: BoxDecoration(
        color: PopupStyles.background,
        borderRadius: BorderRadius.circular(PopupStyles.borderRadius),
      ),
      child: Stack(
        children: [
          ContentWidget(announcement: announcement),
          CloseButtonWidget(),
        ],
      ),
    );
  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key, required this.announcement});
  final Announcement announcement;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(PopupStyles.paddingXXLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TagWidget(tag: announcement.tag, color: announcement.tagColor),
            const SizedBox(height: PopupStyles.spacingXLarge),
            HeaderImageWidget(thumbnail: announcement.thumbnail),
            const SizedBox(height: PopupStyles.spacingXXLarge),
            TitleWidget(title: announcement.title),
            const SizedBox(height: PopupStyles.spacingSmall),
            const Divider(),
            const SizedBox(height: PopupStyles.spacingLarge),
            ContentParserWidget(content: announcement.fullContent),
            const SizedBox(height: PopupStyles.spacingXXXLarge),
          ],
        ),
      ),
    );
  }
}

class TagWidget extends StatelessWidget {
  const TagWidget({super.key, required this.tag, required this.color});
  final String tag;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PopupStyles.paddingLarge,
        vertical: PopupStyles.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(PopupStyles.tagRadius),
      ),
      child: Text(tag, style: PopupStyles.tag),
    );  
  }
}

class HeaderImageWidget extends StatelessWidget {
  final String thumbnail;
  const HeaderImageWidget({super.key, required this.thumbnail});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(PopupStyles.tagRadius),
      child: SizedBox(
        width: double.infinity,
        height: PopupStyles.imageHeight,
        child: Image.asset(
          'assets/$thumbnail', 
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title, style: PopupStyles.title);
  }
}

class CloseButtonWidget extends StatelessWidget {
  const CloseButtonWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: PopupStyles.paddingLarge,
      right: PopupStyles.paddingLarge,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.all(PopupStyles.closeButtonPadding),
          decoration: const BoxDecoration(
            color: PopupStyles.background,
            shape: BoxShape.circle,
            boxShadow: [PopupStyles.closeButtonShadow],
          ),
          child: Icon(
            Icons.close,
            size: PopupStyles.iconSizeSmall,
            color: PopupStyles.iconColor,
          ),
        ),
      ),
    );
  }
}

class ContentParserWidget extends StatelessWidget {
  const ContentParserWidget({super.key, required this.content});
  final String content;
  @override
  Widget build(BuildContext context) {
    final widgets = ContentParserService.parse(content);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

class ContentParserService {
  static const _patterns = {
    '📍 Lokasi:': _InfoConfig(icon: Icons.location_on, prefix: '📍 Lokasi:'),
    '📅 Periode Berlaku:': _InfoConfig(
      icon: Icons.calendar_today,
      prefix: '📅 Periode Berlaku:',
    ),
    '🕗 Jam Operasional Baru:': _InfoConfig(
      icon: Icons.access_time,
      prefix: '🕗 Jam Operasional Baru:',
    ),
    '⚡Keterangan Tambahan:': _InfoConfig(
      isSectionTitle: true,
      prefix: '⚡Keterangan Tambahan:',
    ),
    '📌 Catatan Penting:': _InfoConfig(
      isSectionTitle: true,
      prefix: '📌 Catatan Penting:',
    ),
    '• ': _InfoConfig(isBullet: true, prefix: '• '),
  };

  static List<Widget> parse(String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];
    for (final line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: PopupStyles.spacingMedium));
        continue;
      }
      widgets.add(_parseLine(line));
    }
    return widgets;
  }

  static Widget _parseLine(String line) {
    if (line.contains('Tetap semangat belajar')) {
      return ConclusionTextWidget(text: line);
    }
    for (final pattern in _patterns.keys) {
      if (line.startsWith(pattern)) {
        final config = _patterns[pattern]!;
        if (config.isSectionTitle) {
          return SectionTitleWidget(title: line);
        } else if (config.isBullet) {
          return BulletPointWidget(
            text: line.replaceFirst(config.prefix, '').trim(),
          );
        } else {
          return InfoRowWidget(
            icon: config.icon!,
            text: line.replaceFirst(config.prefix, '').trim(),
          );
        }
      }
    }
    return DefaultTextWidget(text: line);
  }
}

class _InfoConfig {
  final IconData? icon;
  final bool isSectionTitle;
  final bool isBullet;
  final String prefix;

  const _InfoConfig({
    this.icon,
    this.isSectionTitle = false,
    this.isBullet = false,
    required this.prefix,
  });
}

class InfoRowWidget extends StatelessWidget {
  const InfoRowWidget({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PopupStyles.spacingXLarge),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: PopupStyles.iconSizeSmall,
            color: PopupStyles.infoIconColor,
          ),
          const SizedBox(width: PopupStyles.spacingMedium),
          Expanded(child: Text(text, style: PopupStyles.content)),
        ],
      ),
    );
  }
}

class BulletPointWidget extends StatelessWidget {
  const BulletPointWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: PopupStyles.paddingMedium,
        bottom: PopupStyles.spacingMedium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: PopupStyles.paddingLarge),
            width: PopupStyles.bulletSize,
            height: PopupStyles.bulletSize,
            decoration: const BoxDecoration(
              color: PopupStyles.bulletColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: PopupStyles.spacingMedium),
          Expanded(child: Text(text, style: PopupStyles.content)),
        ],
      ),
    );
  }
}

class SectionTitleWidget extends StatelessWidget {
  const SectionTitleWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PopupStyles.spacingMedium),
      child: Text(title, style: PopupStyles.sectionTitle),
    );
  }
}

class ConclusionTextWidget extends StatelessWidget {
  const ConclusionTextWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: PopupStyles.spacingXXLarge),
      child: Text(
        text,
        style: PopupStyles.conclusion,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class DefaultTextWidget extends StatelessWidget {
  const DefaultTextWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PopupStyles.paddingSmall),
      child: Text(text, style: PopupStyles.content),
    );
  }
}
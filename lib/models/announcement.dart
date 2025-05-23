import 'package:flutter/material.dart';

class Announcement {
  final String id;
  final String tag;
  final Color tagColor;
  final String timeAgo;
  final String title;
  final String description;
  final String fullContent;
  final String department;
  final String? imageUrl;

  Announcement({
    required this.id,
    required this.tag,
    required this.tagColor,
    required this.timeAgo,
    required this.title,
    required this.description,
    required this.fullContent,
    required this.department,
    this.imageUrl,
  });
}

class Event {
  final String id;
  final String title;
  final String description;
  final String category;
  final Color color;

  final String? location;
  final DateTime? startTime;
  final DateTime? endTime;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.color,
    this.location,
    this.startTime,
    this.endTime,
  });
}

class EventBanner {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;
  final Color tagColor;

  EventBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
    required this.tagColor,
  });
}

// class Announcement {
//   final String title;
//   final String tag;
//   final Color tagColor;
//   final String fullContent;
//
//   Announcement({
//     required this.title,
//     required this.tag,
//     required this.tagColor,
//     required this.fullContent,
//   });
// }

class EventCategory {
  final String name;
  final Color color;
  const EventCategory({required this.name, required this.color});
}

class EventModel {
  final String title;
  final String time;
  final String date;
  final String location;
  final EventCategory category;
  bool isBookmarked;

  EventModel({
    required this.title,
    required this.time,
    required this.date,
    required this.location,
    required this.category,
    this.isBookmarked = true,
  });
}

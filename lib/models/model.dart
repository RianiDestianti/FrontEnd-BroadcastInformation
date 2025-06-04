import 'package:flutter/material.dart';

class NavigationItem {
  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;

  const NavigationItem({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
  });
}

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

class UserProfile {
  final String name;
  final String studentId;
  final String role;
  final String email;
  final String department;

  const UserProfile({
    required this.name,
    required this.studentId,
    required this.role,
    required this.email,
    required this.department,
  });
}


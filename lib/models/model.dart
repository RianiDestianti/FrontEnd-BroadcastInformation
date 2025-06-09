import 'package:flutter/material.dart';

// layout
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

// home & popup
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

// model
class EventCategory {
  final String name;
  final Color color;
  const EventCategory({required this.name, required this.color});
}

// profile
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

// home
class EventBanner {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;
  final Color tagColor;

  const EventBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
    required this.tagColor,
  });
}

// home
class CategoryData {
  final String name;
  final Color color;
  final IconData icon;

  const CategoryData({
    required this.name,
    required this.color,
    required this.icon,
  });
}
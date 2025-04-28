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

  Announcement({
    required this.id,
    required this.tag,
    required this.tagColor,
    required this.timeAgo,
    required this.title,
    required this.description,
    required this.fullContent,
    required this.department,
  });
}

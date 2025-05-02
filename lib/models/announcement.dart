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

class Event {
  final String id;
  final String title;
  final String description;
  final String category;
  final Color color;
  
  // Optional fields
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

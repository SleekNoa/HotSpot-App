// lib/models/event.dart
// Core data model for HotSpot events.

import 'package:flutter/material.dart';

enum EventCategory { music, food, arts, outdoors, sports, community, other }

enum RsvpStatus { none, interested, going }

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final double distanceMiles;
  final EventCategory category;
  final double? price;
  final int friendsGoing;
  final String? imageUrl;
  final RsvpStatus rsvpStatus;
  final bool isSaved;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.distanceMiles,
    required this.category,
    this.price,
    this.friendsGoing = 0,
    this.imageUrl,
    this.rsvpStatus = RsvpStatus.none,
    this.isSaved = false,
  });

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? location,
    double? distanceMiles,
    EventCategory? category,
    double? price,
    int? friendsGoing,
    String? imageUrl,
    RsvpStatus? rsvpStatus,
    bool? isSaved,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      distanceMiles: distanceMiles ?? this.distanceMiles,
      category: category ?? this.category,
      price: price ?? this.price,
      friendsGoing: friendsGoing ?? this.friendsGoing,
      imageUrl: imageUrl ?? this.imageUrl,
      rsvpStatus: rsvpStatus ?? this.rsvpStatus,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  String get categoryLabel {
    switch (category) {
      case EventCategory.music:
        return 'Music';
      case EventCategory.food:
        return 'Food';
      case EventCategory.arts:
        return 'Arts';
      case EventCategory.outdoors:
        return 'Outdoors';
      case EventCategory.sports:
        return 'Sports';
      case EventCategory.community:
        return 'Community';
      case EventCategory.other:
        return 'Other';
    }
  }

  Color get categoryColor {
    switch (category) {
      case EventCategory.music:
        return const Color(0xFFFBBF24);
      case EventCategory.food:
        return const Color(0xFF34D399);
      case EventCategory.arts:
        return const Color(0xFFA78BFA);
      case EventCategory.outdoors:
        return const Color(0xFF6EE7B7);
      case EventCategory.sports:
        return const Color(0xFF60A5FA);
      case EventCategory.community:
        return const Color(0xFFFCA5A5);
      case EventCategory.other:
        return const Color(0xFFD1D5DB);
    }
  }

  bool get isFree => price == null || price == 0;

  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  bool get isUpcoming => dateTime.isAfter(DateTime.now());
}

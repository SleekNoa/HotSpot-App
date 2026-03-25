// lib/widgets/event_card.dart
// Reusable card component used on Home and Calendar screens.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import '../providers/event_providers.dart';

class EventCard extends ConsumerWidget {
  final Event event;
  final VoidCallback? onTap;
  final bool showRsvpButton;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.showRsvpButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = DateFormat('E, MMM d - h:mm a').format(event.dateTime);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                color: event.categoryColor.withOpacity(0.3),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _categoryIcon(event.category),
                      size: 48,
                      color: event.categoryColor.withOpacity(0.8),
                    ),
                  ),
                  if (event.isToday)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'TODAY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: event.isFree
                            ? const Color(0xFF10B981)
                            : Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        event.isFree
                            ? 'FREE'
                            : '\$${event.price!.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: event.categoryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      event.categoryLabel.toUpperCase(),
                      style: TextStyle(
                        color: event.categoryColor.withOpacity(1),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 13, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '$dateStr - ${event.distanceMiles} mi',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (event.friendsGoing > 0) ...[
                        Icon(Icons.people, size: 15, color: Colors.green.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${event.friendsGoing} going',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _toggleSave(ref),
                        child: Icon(
                          event.isSaved ? Icons.star : Icons.star_border,
                          color: event.isSaved
                              ? const Color(0xFFF59E0B)
                              : Colors.grey.shade400,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.ios_share, color: Colors.grey.shade400, size: 20),
                      const SizedBox(width: 12),
                      if (showRsvpButton)
                        GestureDetector(
                          onTap: () => _cycleRsvp(ref),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: _rsvpColor(event.rsvpStatus),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _rsvpLabel(event.rsvpStatus),
                              style: TextStyle(
                                color: _rsvpTextColor(event.rsvpStatus),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cycleRsvp(WidgetRef ref) {
    final next = _nextStatus(event.rsvpStatus);
    ref.read(eventRepositoryProvider).updateRsvp(event.id, next);
  }

  void _toggleSave(WidgetRef ref) {
    ref.read(eventRepositoryProvider).toggleSaved(event.id);
  }

  RsvpStatus _nextStatus(RsvpStatus status) {
    switch (status) {
      case RsvpStatus.none:
        return RsvpStatus.interested;
      case RsvpStatus.interested:
        return RsvpStatus.going;
      case RsvpStatus.going:
        return RsvpStatus.none;
    }
  }

  Color _rsvpColor(RsvpStatus status) {
    switch (status) {
      case RsvpStatus.none:
        return Colors.grey.shade200;
      case RsvpStatus.interested:
        return const Color(0xFFFBBF24);
      case RsvpStatus.going:
        return const Color(0xFF2563EB);
    }
  }

  String _rsvpLabel(RsvpStatus status) {
    switch (status) {
      case RsvpStatus.none:
        return 'RSVP';
      case RsvpStatus.interested:
        return 'Interested';
      case RsvpStatus.going:
        return 'Going';
    }
  }

  Color _rsvpTextColor(RsvpStatus status) {
    switch (status) {
      case RsvpStatus.none:
        return Colors.grey.shade700;
      case RsvpStatus.interested:
        return Colors.black87;
      case RsvpStatus.going:
        return Colors.white;
    }
  }

  IconData _categoryIcon(EventCategory category) {
    switch (category) {
      case EventCategory.music:
        return Icons.music_note;
      case EventCategory.food:
        return Icons.restaurant;
      case EventCategory.arts:
        return Icons.palette;
      case EventCategory.outdoors:
        return Icons.park;
      case EventCategory.sports:
        return Icons.sports;
      case EventCategory.community:
        return Icons.people;
      case EventCategory.other:
        return Icons.event;
    }
  }
}

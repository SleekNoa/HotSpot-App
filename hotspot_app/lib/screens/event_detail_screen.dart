// lib/screens/event_detail_screen.dart
// Full event view. V0.1: static display, RSVP toggle, share placeholder.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import '../providers/event_providers.dart';

class EventDetailScreen extends ConsumerWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final latestEvent = eventsAsync.maybeWhen(
      data: (events) => events.firstWhere(
        (e) => e.id == event.id,
        orElse: () => event,
      ),
      orElse: () => event,
    );

    final dateStr =
        DateFormat('EEEE, MMMM d, y - h:mm a').format(latestEvent.dateTime);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: latestEvent.categoryColor.withOpacity(0.5),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back,
                    size: 18, color: Color(0xFF111827)),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    latestEvent.isSaved ? Icons.star : Icons.star_border,
                    size: 18,
                    color: latestEvent.isSaved
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF111827),
                  ),
                ),
                onPressed: () {
                  ref
                      .read(eventRepositoryProvider)
                      .toggleSaved(latestEvent.id);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        latestEvent.isSaved ? 'Removed from saved' : 'Saved',
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.ios_share,
                      size: 18, color: Color(0xFF111827)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share coming soon')),
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: latestEvent.categoryColor.withOpacity(0.25),
                child: Center(
                  child: Icon(
                    _categoryIcon(latestEvent.category),
                    size: 72,
                    color: latestEvent.categoryColor,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: latestEvent.categoryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          latestEvent.categoryLabel.toUpperCase(),
                          style: TextStyle(
                            color: latestEvent.categoryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: latestEvent.isFree
                              ? const Color(0xFF10B981).withOpacity(0.15)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          latestEvent.isFree
                              ? 'FREE'
                              : '\$${latestEvent.price!.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: latestEvent.isFree
                                ? const Color(0xFF059669)
                                : Colors.grey.shade700,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (latestEvent.isToday) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'TODAY',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    latestEvent.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _infoRow(Icons.access_time, dateStr),
                  const SizedBox(height: 10),
                  _infoRow(Icons.location_on, latestEvent.location),
                  const SizedBox(height: 10),
                  _infoRow(
                    Icons.directions,
                    '${latestEvent.distanceMiles} miles away',
                  ),
                  if (latestEvent.friendsGoing > 0) ...[
                    const SizedBox(height: 10),
                    _infoRow(
                      Icons.people,
                      '${latestEvent.friendsGoing} friends going',
                      iconColor: Colors.green.shade600,
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'About this event',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    latestEvent.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF374151),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildRsvpSection(ref, latestEvent),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, {Color? iconColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor ?? const Color(0xFF2563EB)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRsvpSection(WidgetRef ref, Event event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Are you going?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _rsvpOption(ref, event, RsvpStatus.interested, 'Interested', Icons.star_half),
            const SizedBox(width: 10),
            _rsvpOption(ref, event, RsvpStatus.going, 'Going', Icons.check_circle),
          ],
        ),
      ],
    );
  }

  Widget _rsvpOption(
    WidgetRef ref,
    Event event,
    RsvpStatus status,
    String label,
    IconData icon,
  ) {
    final isSelected = event.rsvpStatus == status;
    final activeColor = status == RsvpStatus.going
        ? const Color(0xFF2563EB)
        : const Color(0xFFF59E0B);

    return GestureDetector(
      onTap: () {
        final next = isSelected ? RsvpStatus.none : status;
        ref.read(eventRepositoryProvider).updateRsvp(event.id, next);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey.shade500,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
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

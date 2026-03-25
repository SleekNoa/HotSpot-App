// lib/screens/calendar_screen.dart
// Shows events the user has RSVP'd to (Going or Interested).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';
import '../providers/event_providers.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(eventsAsync),
            Expanded(
              child: eventsAsync.when(
                data: (events) {
                  final rsvpdEvents = _rsvpdEvents(events);
                  return rsvpdEvents.isEmpty
                      ? _buildEmptyState()
                      : _buildEventList(context, rsvpdEvents);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Failed to load calendar',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Event> _rsvpdEvents(List<Event> events) {
    return events.where((e) => e.rsvpStatus != RsvpStatus.none).toList();
  }

  Widget _buildTopBar(AsyncValue<List<Event>> eventsAsync) {
    final count = eventsAsync.maybeWhen(
      data: (events) => _rsvpdEvents(events).length,
      orElse: () => 0,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hot',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    TextSpan(
                      text: 'Spot',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                color: Colors.grey.shade600,
                onPressed: () {},
              ),
            ],
          ),
          const Text(
            'My Calendar',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count == 0 ? 'No upcoming plans yet' : '$count upcoming event${count == 1 ? '' : 's'}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'No upcoming events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'RSVP to events on the Discover tab and they will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: switch tabs when wiring tab controller
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Browse Events',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(BuildContext context, List<Event> events) {
    final goingEvents =
        events.where((e) => e.rsvpStatus == RsvpStatus.going).toList();
    final interestedEvents =
        events.where((e) => e.rsvpStatus == RsvpStatus.interested).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        if (goingEvents.isNotEmpty) ...[
          _sectionHeader('Going', const Color(0xFF2563EB)),
          ...goingEvents.map((e) => EventCard(
                event: e,
                onTap: () => _openDetail(context, e),
              )),
        ],
        if (interestedEvents.isNotEmpty) ...[
          _sectionHeader('Interested', const Color(0xFFF59E0B)),
          ...interestedEvents.map((e) => EventCard(
                event: e,
                onTap: () => _openDetail(context, e),
              )),
        ],
      ],
    );
  }

  Widget _sectionHeader(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(event: event),
      ),
    );
  }
}

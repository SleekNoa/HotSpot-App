// lib/screens/calendar_screen.dart
// Calendar view with highlighted event days and RSVP list.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/event.dart';
import '../providers/event_providers.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';
import '../main.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedSegment = 'All';

  final List<String> _segments = ['All', 'Going', 'Interested', 'Saved'];

  @override
  Widget build(BuildContext context) {
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
                  final eventsByDay = _groupEventsByDay(rsvpdEvents);
                  final filteredEvents = _filteredEvents(events, rsvpdEvents);
                  return Column(
                    children: [
                      _buildCalendar(eventsByDay),
                      _buildSegmentRow(),
                      const SizedBox(height: 8),
                      Expanded(
                        child: filteredEvents.isEmpty
                            ? SingleChildScrollView(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildEmptyState(),
                              )
                            : _buildEventList(filteredEvents),
                      ),
                    ],
                  );
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

  List<Event> _filteredEvents(List<Event> allEvents, List<Event> rsvpdEvents) {
    List<Event> base;
    switch (_selectedSegment) {
      case 'Going':
        base = allEvents.where((e) => e.rsvpStatus == RsvpStatus.going).toList();
        break;
      case 'Interested':
        base = allEvents
            .where((e) => e.rsvpStatus == RsvpStatus.interested)
            .toList();
        break;
      case 'Saved':
        base = allEvents.where((e) => e.isSaved).toList();
        break;
      default:
        base = rsvpdEvents;
    }

    if (_selectedDay == null) {
      final sorted = List<Event>.from(base);
      sorted.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      return sorted;
    }

    final filtered =
        base.where((e) => isSameDay(e.dateTime, _selectedDay)).toList();
    filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return filtered;
  }

  Map<DateTime, List<Event>> _groupEventsByDay(List<Event> events) {
    final map = <DateTime, List<Event>>{};
    for (final event in events) {
      final key = DateTime(event.dateTime.year, event.dateTime.month, event.dateTime.day);
      map.putIfAbsent(key, () => []).add(event);
    }
    return map;
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

  Widget _buildCalendar(Map<DateTime, List<Event>> eventsByDay) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TableCalendar<Event>(
        firstDay: DateTime(DateTime.now().year - 2, 1, 1),
        lastDay: DateTime(DateTime.now().year + 2, 12, 31),
        focusedDay: _focusedDay,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon: const Icon(Icons.chevron_left),
          rightChevronIcon: const Icon(Icons.chevron_right),
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
          weekendStyle: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: const Color(0xFF2563EB).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          selectedDecoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(8),
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        selectedDayPredicate: (day) => _selectedDay != null && isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            final hasEvents = eventsByDay[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)]?.isNotEmpty ?? false;
            _selectedDay = hasEvents ? selectedDay : null;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
          if (_selectedDay != null && !_isSameMonth(_selectedDay, focusedDay)) {
            setState(() {
              _selectedDay = null;
            });
          }
        },
        onHeaderTapped: (focusedDay) async {
          final picked = await showDatePicker(
            context: context,
            initialDate: focusedDay,
            firstDate: DateTime(DateTime.now().year - 2, 1, 1),
            lastDate: DateTime(DateTime.now().year + 2, 12, 31),
          );
          if (picked != null) {
            setState(() {
              _focusedDay = picked;
              _selectedDay = null;
            });
          }
        },
        eventLoader: (day) {
          final key = DateTime(day.year, day.month, day.day);
          return eventsByDay[key] ?? [];
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final key = DateTime(day.year, day.month, day.day);
            final hasEvents = eventsByDay[key]?.isNotEmpty ?? false;
            if (!hasEvents) return null;
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
          todayBuilder: (context, day, focusedDay) {
            final key = DateTime(day.year, day.month, day.day);
            final hasEvents = eventsByDay[key]?.isNotEmpty ?? false;
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: hasEvents
                    ? const Color(0xFF2563EB).withOpacity(0.2)
                    : const Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2563EB), width: 1),
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSegmentRow() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _segments.length,
        itemBuilder: (context, index) {
          final segment = _segments[index];
          final isSelected = _selectedSegment == segment;

          return GestureDetector(
            onTap: () => setState(() => _selectedSegment = segment),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : Colors.grey.shade300,
                ),
              ),
              child: Text(
                segment,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
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
            Icon(Icons.calendar_today_outlined, size: 56, color: Colors.grey.shade300),
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
              _selectedDay == null
                  ? _selectedSegment == 'Saved'
                      ? 'Save events to see them here.'
                      : 'RSVP to events on the Discover tab and they will show up here.'
                  : 'No events on this day.',
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
                MainNavigation.of(context)?.setTab(0);
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

  Widget _buildEventList(List<Event> events) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        ...events.map((e) => EventCard(
              event: e,
              onTap: () => _openDetail(e),
            )),
      ],
    );
  }

  void _openDetail(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(event: event),
      ),
    );
  }

  bool _isSameMonth(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year && a.month == b.month;
  }
}

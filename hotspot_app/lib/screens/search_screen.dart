// lib/screens/search_screen.dart
// Simple search UI for events.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';
import '../providers/event_providers.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search events, places, keywords',
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => _query = value.trim()),
        ),
      ),
      body: eventsAsync.when(
        data: (events) => _buildResults(events),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Failed to load events',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(List<Event> events) {
    final results = _query.isEmpty
        ? events
        : events.where((e) {
            final haystack = '${e.title} ${e.description} ${e.location}'
                .toLowerCase();
            return haystack.contains(_query.toLowerCase());
          }).toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No results',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final event = results[index];
        return EventCard(
          event: event,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetailScreen(event: event),
              ),
            );
          },
        );
      },
    );
  }
}

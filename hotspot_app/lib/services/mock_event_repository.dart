import 'dart:async';

import '../models/event.dart';
import 'event_repository.dart';
import 'mock_data.dart';

class MockEventRepository implements EventRepository {
  final StreamController<List<Event>> _controller =
      StreamController<List<Event>>.broadcast();
  final List<Event> _events;

  MockEventRepository({List<Event>? seed})
      : _events = List<Event>.from(seed ?? MockData.getEvents());

  @override
  Stream<List<Event>> watchEvents() async* {
    yield List<Event>.unmodifiable(_events);
    yield* _controller.stream;
  }

  @override
  Future<void> updateRsvp(String eventId, RsvpStatus status) async {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index == -1) return;
    _events[index] = _events[index].copyWith(rsvpStatus: status);
    _emit();
  }

  @override
  Future<void> toggleSaved(String eventId) async {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index == -1) return;
    final current = _events[index];
    _events[index] = current.copyWith(isSaved: !current.isSaved);
    _emit();
  }

  void _emit() {
    if (_controller.isClosed) return;
    _controller.add(List<Event>.unmodifiable(_events));
  }

  @override
  void dispose() {
    _controller.close();
  }
}

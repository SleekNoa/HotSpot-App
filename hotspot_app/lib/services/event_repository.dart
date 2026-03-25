import '../models/event.dart';

abstract class EventRepository {
  Stream<List<Event>> watchEvents();
  Future<void> updateRsvp(String eventId, RsvpStatus status);
  Future<void> toggleSaved(String eventId);
  void dispose() {}
}

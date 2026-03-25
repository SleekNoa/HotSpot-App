import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';
import '../services/event_repository.dart';
import '../services/mock_event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final repo = MockEventRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

final eventsProvider = StreamProvider<List<Event>>((ref) {
  final repo = ref.watch(eventRepositoryProvider);
  return repo.watchEvents();
});

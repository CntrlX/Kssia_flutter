import 'dart:developer';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/services/api_routes/events_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_notifier.g.dart';
@riverpod
class EventsNotifier extends _$EventsNotifier {
  List<Event> events = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 20;
  bool hasMore = true;

  @override
  List<Event> build() {
    return [];
  }

  Future<void> fetchMoreEvents() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newEvents = await ref
          .read(fetchEventsProvider(pageNo: pageNo, limit: limit).future);
      events = [...events, ...newEvents];
      pageNo++;
      hasMore = newEvents.length == limit;
      state = events;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
      log('im in people $events');
    }
  }

  // Function to refresh feed while staying on the current page
  Future<void> refreshFeed() async {
    if (isLoading) return;

    isLoading = true;

    try {
      // Fetch events again for the current page without changing pageNo
      final refreshedEvents = await ref
          .read(fetchEventsProvider(pageNo: pageNo, limit: limit).future);

      // Replace current events with refreshed events for the current page
      events = refreshedEvents;
      
      // Update state with the refreshed events
      state = events;

      // Check if there are more events to load
      hasMore = refreshedEvents.length == limit;
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
      log('Feed refreshed with $events');
    }
  }
}

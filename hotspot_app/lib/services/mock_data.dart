// lib/services/mock_data.dart
// V0.1: All events are hardcoded here.
// Later phases replace this with a real data source.

import '../models/event.dart';

class MockData {
  static List<Event> getEvents() {
    final now = DateTime.now();

    return [
      Event(
        id: '1',
        title: 'Live Music at NewBo Market',
        description:
            'Local Cedar Rapids bands take the stage at NewBo City Market. Free\ entry, full bar, great vibes. Rain or shine - it is indoors.',
        dateTime: DateTime(now.year, now.month, now.day, 20, 0),
        location: 'NewBo City Market, Cedar Rapids',
        distanceMiles: 1.2,
        category: EventCategory.music,
        price: null,
        friendsGoing: 3,
      ),
      Event(
        id: '2',
        title: 'Cedar Rapids Farmers Market',
        description:
            'Fresh produce, local vendors, live acoustic music, and the best cinnamon rolls in eastern Iowa. Weekly Saturday tradition.',
        dateTime: DateTime(now.year, now.month, now.day + 1, 8, 0),
        location: 'Downtown Cedar Rapids',
        distanceMiles: 0.8,
        category: EventCategory.community,
        price: null,
        friendsGoing: 7,
      ),
      Event(
        id: '3',
        title: 'Trivia Night at Parlor City',
        description:
            'Teams of up to 6. \$5\ entry. Winner takes 50% of the pot. Categories include pop culture, history, and local Iowa trivia.',
        dateTime: DateTime(now.year, now.month, now.day + 2, 19, 30),
        location: 'Parlor City Pub, Marion',
        distanceMiles: 2.1,
        category: EventCategory.community,
        price: 5.0,
        friendsGoing: 1,
      ),
      Event(
        id: '4',
        title: 'Pottery Wheel Beginner Workshop',
        description:
            'No experience needed. All materials included. Learn the basics from local artist Maya Chen. Limited to 12 participants.',
        dateTime: DateTime(now.year, now.month, now.day + 3, 14, 0),
        location: 'Artifact Studios, Cedar Rapids',
        distanceMiles: 3.4,
        category: EventCategory.arts,
        price: 45.0,
        friendsGoing: 0,
      ),
      Event(
        id: '5',
        title: 'Cedar Lake Trail Run',
        description:
            'Casual 5K group run around Cedar Lake. All paces welcome. Meet at the pavilion. Coffee provided after.',
        dateTime: DateTime(now.year, now.month, now.day + 4, 7, 0),
        location: 'Cedar Lake Pavilion',
        distanceMiles: 4.7,
        category: EventCategory.outdoors,
        price: null,
        friendsGoing: 5,
      ),
      Event(
        id: '6',
        title: 'Food Truck Rally - Summer Kickoff',
        description:
            '15+ food trucks, local craft beer garden, live DJ. Family friendly until 8PM, 21+ after. Presented by CR Downtown District.',
        dateTime: DateTime(now.year, now.month, now.day + 6, 11, 0),
        location: 'Westdale Town Center',
        distanceMiles: 5.9,
        category: EventCategory.food,
        price: null,
        friendsGoing: 12,
      ),
    ];
  }
}



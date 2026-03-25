import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hotspot_app/main.dart';

void main() {
  testWidgets('HotSpot app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: HotSpotApp()));
    expect(find.byType(MainNavigation), findsOneWidget);
  });
}

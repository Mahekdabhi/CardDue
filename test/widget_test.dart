import 'package:flutter_test/flutter_test.dart';
import 'package:card_due/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CardDueApp(),
      ),
    );

    // Verify that our dashboard title is rendered.
    expect(find.text('CardDue'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:sodium/app.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SodiumApp());

    expect(find.text('Sodium Recipe App'), findsOneWidget);
  });
}

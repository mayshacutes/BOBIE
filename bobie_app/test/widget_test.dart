import 'package:flutter_test/flutter_test.dart';
import 'package:bobie_app/main.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BobieApp());
    expect(find.text('BOBIE'), findsNothing);
  });
}

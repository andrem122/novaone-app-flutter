import 'package:flutter_test/flutter_test.dart';

class TestUtils {
  /// Writes a [value] to a [TextFormField] and verifies the text has been written
  static Future<void> writeTextAndVerify(
      {required String value,
      required WidgetTester tester,
      required Finder textFormField}) async {
    await tester.tap(textFormField); // acquire focus
    await tester.enterText(textFormField, value); // enter text
    await tester.pumpAndSettle();
    expect(find.text(value), findsOneWidget); // verify text has been written
  }
}

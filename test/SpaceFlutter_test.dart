import 'package:flutter_test/flutter_test.dart';

import 'package:spaceflutter/SpaceFlutterApplication.dart';

void main() {
  testWidgets('Application starts at menu', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    SpaceFlutterApplication app = new SpaceFlutterApplication();
    await tester.pumpWidget(app);

    // Verify that our application start with menu page.
    expect(find.text('Start Game'), findsOneWidget);

    // Verify initialization of size
    expect(SpaceFlutterApplication.height, isNotNull);
    expect(SpaceFlutterApplication.width, isNotNull);

  });

}

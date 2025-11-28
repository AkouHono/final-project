import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eduflash/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(EduFlash());

    // Verify app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

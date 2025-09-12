// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:Bookrithm/main.dart';
import 'package:Bookrithm/view_controller/view_page.dart';
import 'package:Bookrithm/widgets/common/sidebar.dart';
import 'package:Bookrithm/widgets/registry/visualization_area.dart';

void main() {
  testWidgets('Main UI smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Bookrithm());

    // Verify that the main components are present.
    expect(find.byType(DataVisualizer), findsOneWidget);
    expect(find.byType(Sidebar), findsOneWidget);
    expect(find.byType(VisualizationArea), findsOneWidget);
  });
}

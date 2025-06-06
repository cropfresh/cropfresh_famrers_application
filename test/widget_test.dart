// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cropfresh_farmers_app/main.dart';

void main() {
  testWidgets('CropFresh app launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CropFreshFarmersApp());

    // Verify that the splash screen is displayed with CropFresh branding
    expect(find.text('CropFresh'), findsOneWidget);
    
    // Allow time for splash screen to complete
    await tester.pump(const Duration(seconds: 1));
    
    // Verify the app doesn't crash during initial load
    expect(find.byType(MaterialApp), findsOneWidget);
  });
} 
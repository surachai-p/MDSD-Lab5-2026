import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_marketplace_riverpod_trial/main.dart';

void main() {
  testWidgets('saves an item with Riverpod', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('รายการโปรด: 0'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'บันทึก').first);
    await tester.pump();

    expect(find.text('รายการโปรด: 1'), findsOneWidget);
    expect(find.text('บันทึกแล้ว'), findsOneWidget);
  });
}

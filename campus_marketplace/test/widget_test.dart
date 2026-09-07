import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:campus_marketplace/main.dart';
import 'package:campus_marketplace/models/favorites_model.dart';

void main() {
  testWidgets('saves an item and opens the favorites route', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FavoritesModel(),
        child: const MyApp(),
      ),
    );

    expect(find.text(' 0'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'บันทึก').first);
    await tester.pump();

    expect(find.text(' 1'), findsOneWidget);
    expect(find.text('บันทึกแล้ว'), findsOneWidget);

    await tester.tap(find.byTooltip('รายการโปรด'));
    await tester.pumpAndSettle();

    expect(find.text('รายการโปรดของฉัน'), findsOneWidget);
    expect(find.text('หนังสือ Calculus มือสอง'), findsOneWidget);
  });
}

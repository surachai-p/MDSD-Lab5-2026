import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:campus_marketplace/main.dart';
import 'package:campus_marketplace/models/favorites_model.dart';

void main() {
  testWidgets('search box filters catalog items', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FavoritesModel(),
        child: const MyApp(),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('หนังสือ Calculus มือสอง'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'หูฟัง');
    await tester.pump();

    expect(find.text('หูฟังไร้สาย (สภาพดี 90%)'), findsOneWidget);
    expect(find.text('หนังสือ Calculus มือสอง'), findsNothing);
  });
}

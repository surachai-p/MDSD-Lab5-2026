import 'package:campus_marketplace/main.dart';
import 'package:campus_marketplace/models/favorites_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('favorites count updates when an item is saved', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FavoritesModel(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Campus Marketplace'), findsOneWidget);
    expect(find.text(' 0'), findsOneWidget);
    expect(find.text(' 1'), findsNothing);

    await tester.tap(find.text('🤍 บันทึกเป็นรายการโปรด').first);
    await tester.pump();

    expect(find.text(' 1'), findsOneWidget);
  });
}

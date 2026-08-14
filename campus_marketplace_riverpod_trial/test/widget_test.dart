import 'package:campus_marketplace_riverpod_trial/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('favorites count updates when item is saved', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('❤️ 0'), findsOneWidget);

    await tester.tap(find.text('บันทึก').first);
    await tester.pump();

    expect(find.text('❤️ 1'), findsOneWidget);
  });
}

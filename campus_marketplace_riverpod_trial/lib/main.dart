import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favorites_notifier.dart';
import 'item.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedItems = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: Text('❤️ ${savedItems.length}')),
      body: ListView(
        children: catalog
            .map(
              (item) => ListTile(
                title: Text(item.title),
                trailing: ElevatedButton(
                  onPressed: () =>
                      ref.read(favoritesProvider.notifier).add(item),
                  child: const Text('บันทึก'),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

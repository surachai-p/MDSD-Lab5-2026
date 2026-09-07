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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _query = '';

  Future<void> _clearFavorites() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ล้างรายการโปรดทั้งหมด?'),
        content: const Text('รายการที่บันทึกไว้ทั้งหมดจะถูกลบ'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('ล้างรายการ'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref.read(favoritesProvider.notifier).clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedItems = ref.watch(favoritesProvider);
    final filteredCatalog = catalog.where((item) {
      return item.title.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('รายการโปรด: ${savedItems.length}'),
        actions: [
          if (savedItems.isNotEmpty)
            IconButton(
              tooltip: 'ล้างรายการโปรดทั้งหมด',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: _clearFavorites,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'ค้นหาสินค้า',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: filteredCatalog.isEmpty
                ? const Center(child: Text('ไม่พบสินค้าที่ค้นหา'))
                : ListView(
                    children: filteredCatalog.map((item) {
                      final alreadySaved = savedItems.any(
                        (saved) => saved.id == item.id,
                      );
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                        trailing: ElevatedButton(
                          onPressed: alreadySaved
                              ? null
                              : () => ref
                                    .read(favoritesProvider.notifier)
                                    .add(item),
                          child: Text(alreadySaved ? 'บันทึกแล้ว' : 'บันทึก'),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'item.dart';
import 'favorites_notifier.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _searchQuery = '';

  void _showClearConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการล้างรายการโปรด'),
        content: const Text('คุณต้องการลบรายการโปรดทั้งหมดใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ref.read(favoritesProvider.notifier).clear();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ล้างรายการโปรดทั้งหมดเรียบร้อยแล้ว')),
              );
            },
            child: const Text('ล้างทั้งหมด'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedItems = ref.watch(favoritesProvider);

    final filteredCatalog = catalog.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('❤️ ${savedItems.length}'),
        actions: [
          if (savedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'ล้างรายการโปรดทั้งหมด',
              onPressed: () => _showClearConfirmDialog(context),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ค้นหาสินค้า...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: filteredCatalog.map((item) {
                final isSaved = savedItems.any((i) => i.id == item.id);
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: ElevatedButton(
                    onPressed: isSaved
                        ? null
                        : () {
                            ref.read(favoritesProvider.notifier).add(item);
                          },
                    child: Text(isSaved ? '❤️ บันทึกแล้ว' : 'บันทึก'),
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

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
  Widget build(BuildContext context) =>
      const MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final savedItems = ref.watch(favoritesProvider);
    final filteredItems = catalog.where((item) {
      final query = _searchQuery.trim().toLowerCase();
      if (query.isEmpty) return true;
      return item.title.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('❤️ ${savedItems.length}'),
        actions: [
          if (savedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ค้นหาสินค้า...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text('ไม่พบสินค้าที่ตรงกับคำค้นหา'))
                : ListView(
                    children: filteredItems.map((item) {
                      final alreadySaved = savedItems.any(
                        (i) => i.id == item.id,
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

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    void confirmClear() {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('ล้างรายการโปรดทั้งหมด?'),
          content: const Text('ข้อมูลสินค้าที่บันทึกไว้จะถูกลบออกทั้งหมด'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                ref.read(favoritesProvider.notifier).clear();
                Navigator.pop(dialogContext);
              },
              child: const Text('ล้างรายการ'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการโปรดของฉัน'),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: confirmClear,
            ),
        ],
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('ยังไม่มีสินค้าที่บันทึกไว้'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        ref.read(favoritesProvider.notifier).remove(item),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'มูลค่ารวม: ฿${favorites.fold<double>(0, (sum, item) => sum + item.price).toStringAsFixed(0)}',
        ),
      ),
    );
  }
}

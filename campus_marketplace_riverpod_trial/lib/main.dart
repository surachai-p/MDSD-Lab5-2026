import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'item.dart';
import 'favorites_notifier.dart';
import 'favorites_page.dart';

void main() {
  // ครอบแอปทั้งหมดด้วย ProviderScope เพียงครั้งเดียวที่จุดเริ่มต้น เทียบเท่า ChangeNotifierProvider
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false, // ปิดริบบิ้น DEBUG มุมขวาบน ไม่ให้บังไอคอนหัวใจใน AppBar
        home: HomePage(),
      );
}

// ใช้ ConsumerWidget แทน StatelessWidget เพื่อรับพารามิเตอร์ "ref" เข้ามาใน build()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final savedItems = ref.watch(favoritesProvider);
    final filtered = _search.isEmpty
        ? catalog
        : catalog.where((it) => it.title.toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('❤️ ${savedItems.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
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
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'ค้นหาสินค้า',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Expanded(
            child: ListView(
              children: filtered
                  .map((item) => ListTile(
                        title: Text(item.title),
                        trailing: ElevatedButton(
                          onPressed: () => ref.read(favoritesProvider.notifier).add(item),
                          child: const Text('บันทึก'),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
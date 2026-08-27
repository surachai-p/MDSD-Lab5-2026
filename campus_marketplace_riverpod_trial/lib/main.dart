import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'item.dart';
import 'favorites_notifier.dart';

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

// ใช้ ConsumerStatefulWidget แทน ConsumerWidget เพราะตอนนี้ต้องเก็บ Ephemeral State (คำค้นหา) ไว้เองด้วย
// เทียบเท่ากับตอนที่โปรเจกต์หลักเปลี่ยน HomePage จาก StatelessWidget กลับเป็น StatefulWidget ในขั้นตอนที่ 5
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // Ephemeral State: คำค้นหามีความหมายแค่ในหน้านี้ ใช้ setState ธรรมดา ไม่ต้องพึ่ง Riverpod
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // ref.watch อ่านค่าปัจจุบันและสมัครรับการอัปเดตอัตโนมัติ เทียบเท่า context.watch
    final savedItems = ref.watch(favoritesProvider);
    final filteredCatalog = catalog
        .where((item) =>
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('❤️ ${savedItems.length}'),
        actions: [
          // ปุ่มนี้โผล่เฉพาะตอนมีรายการโปรดอย่างน้อย 1 ชิ้น เทียบเท่ากับปุ่มล้างทั้งหมดในโปรเจกต์หลัก
          if (savedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'ล้างรายการโปรดทั้งหมด',
              onPressed: () => showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('ล้างรายการโปรดทั้งหมด?'),
                  content: const Text(
                      'ต้องการลบสินค้าที่บันทึกไว้ทั้งหมดออกจากรายการโปรดใช่หรือไม่'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('ยกเลิก'),
                    ),
                    TextButton(
                      onPressed: () {
                        // ref.read(...notifier) ใช้เรียกแก้ไขค่า เทียบเท่า context.read
                        ref.read(favoritesProvider.notifier).clear();
                        Navigator.pop(dialogContext);
                      },
                      child: const Text('ล้างทั้งหมด'),
                    ),
                  ],
                ),
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
                labelText: 'ค้นหาสินค้า',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView(
              children: filteredCatalog
                  .map((item) => ListTile(
                        title: Text(item.title),
                        trailing: ElevatedButton(
                          onPressed: () =>
                              ref.read(favoritesProvider.notifier).add(item),
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

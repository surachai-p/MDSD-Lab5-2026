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
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
}

// เปลี่ยนจาก ConsumerWidget เป็น ConsumerStatefulWidget เพราะตอนนี้ต้องเก็บ
// Ephemeral State (คำค้นหา) ไว้เองด้วย นี่คือคู่เทียบของ StatefulWidget ฝั่ง Riverpod
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _searchQuery = ''; // Ephemeral State: ใช้ setState ธรรมดา ไม่เกี่ยวกับ Riverpod เลย

  // แยกฟังก์ชัน Dialog ยืนยันออกมาต่างหาก เหมือนกับที่ทำในโปรเจกต์หลัก
  void _showClearConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ยืนยันการล้างรายการโปรด'),
        content: const Text('ต้องการลบสินค้าที่บันทึกไว้ทั้งหมดใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              // ref.read(...notifier) เทียบเท่า context.read<FavoritesModel>()
              ref.read(favoritesProvider.notifier).clear();
              Navigator.pop(dialogContext);
            },
            child: const Text('ล้างทั้งหมด', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch อ่านค่าปัจจุบันและสมัครรับการอัปเดตอัตโนมัติ เทียบเท่า context.watch
    final savedItems = ref.watch(favoritesProvider);

    // กรอง catalog ตามคำค้นหา ไม่สนตัวพิมพ์เล็ก-ใหญ่ (เหมือนโจทย์ที่ 1 ในโปรเจกต์หลักทุกประการ)
    final filteredCatalog = catalog
        .where((item) =>
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('❤️ ${savedItems.length}'),
        actions: [
          // แสดงปุ่มล้างเฉพาะเมื่อมีรายการโปรดอย่างน้อย 1 รายการ (เหมือนโจทย์ที่ 2 เดิม)
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
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'ค้นหาสินค้า',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value); // setState ธรรมดา ไม่ต้องพึ่ง ref เลย
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: filteredCatalog.map((item) => ListTile(
                title: Text(item.title),
                trailing: ElevatedButton(
                  onPressed: () => ref.read(favoritesProvider.notifier).add(item),
                  child: const Text('บันทึก'),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'item.dart';
import 'favorites_notifier.dart';

void main() {
  // ครอบแอปทั้งหมดด้วย ProviderScope เพื่อใช้งาน Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false, // ปิดริบบิ้น DEBUG
    home: HomePage(),
  );
}

// ใช้ StatefulWidget ร่วมกับ Consumer เพื่อทำระบบค้นหา (Ephemeral State)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = ''; // State สำหรับเก็บคำค้นหาในหน้านี้

  @override
  Widget build(BuildContext context) {
    // กรองสินค้าใน catalog จาก item.dart ตามคำค้นหา
    final filteredCatalog = catalog.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        // ใช้ Consumer แบบเจาะจงเพื่ออ่านจำนวนรายการโปรดมาแสดงตรงหัวแอป
        title: Consumer(
          builder: (context, ref, child) {
            final savedItems = ref.watch(favoritesProvider);
            return Text('❤️ ${savedItems.length}');
          },
        ),
        actions: [
          // ปุ่ม "ล้างรายการโปรดทั้งหมด" พร้อม Dialog ยืนยัน
          Consumer(
            builder: (context, ref, child) {
              final savedItems = ref.watch(favoritesProvider);
              // เงื่อนไข: ถ้าไม่มีสินค้าโปรดเลย จะซ่อนปุ่มนี้ไปก่อน
              if (savedItems.isEmpty) return const SizedBox.shrink();

              return IconButton(
                icon: const Icon(Icons.delete_sweep, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('ยืนยันการล้างข้อมูล'),
                      content: const Text(
                        'คุณต้องการลบรายการโปรดทั้งหมดใช่หรือไม่?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('ยกเลิก'),
                        ),
                        TextButton(
                          onPressed: () {
                            // ใช้ ref.read สั่งเคลียร์ลิสต์เป็นค่าว่างใน StateNotifier
                            ref.read(favoritesProvider.notifier).state = [];
                            Navigator.pop(ctx); // ปิด Dialog
                          },
                          child: const Text(
                            'ล้างทั้งหมด',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ช่องค้นหาสินค้า (โจทย์ข้อที่ 1)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'ค้นหาสินค้า...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery =
                      value; // พิมพ์แล้วสั่งรีเฟรชหน้าจอเพื่อกรองข้อมูล
                });
              },
            ),
          ),
          // แสดงรายการสินค้าที่กรองแล้ว
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final savedItems = ref.watch(favoritesProvider);

                return ListView(
                  children: filteredCatalog.map((item) {
                    // เช็กว่าไอเทมนี้ถูกบันทึกไปแล้วหรือยัง
                    final isSaved = savedItems.any((i) => i.id == item.id);

                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                      trailing: ElevatedButton(
                        // ถ้าบันทึกแล้วให้ปิดปุ่ม (onPressed: null) ป้องกันกดซ้ำ
                        onPressed: isSaved
                            ? null
                            : () => ref
                                  .read(favoritesProvider.notifier)
                                  .add(item),
                        child: Text(isSaved ? 'บันทึกแล้ว' : 'บันทึก'),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

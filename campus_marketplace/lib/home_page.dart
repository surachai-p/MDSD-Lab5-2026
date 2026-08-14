import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/item.dart';
import 'models/favorites_model.dart';
import 'widgets/item_list_section.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  // เปลี่ยนกลับเป็น StatefulWidget เฉพาะเพื่อเก็บคำค้นหา (Ephemeral State)
  // ส่วน favorites ยังคงอ่านผ่าน Provider เหมือนเดิม ไม่เกี่ยวกัน
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = ''; // Ephemeral State: ใช้แค่ในหน้านี้ ไม่มีหน้าอื่นต้องรู้

  @override
  Widget build(BuildContext context) {
    // กรอง catalog ตามคำค้นหา ไม่สนตัวพิมพ์เล็ก-ใหญ่
    final filteredCatalog = catalog
        .where((item) =>
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Marketplace'),
        actions: [
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite),
                // .watch ทำให้ตัวเลขนี้อัปเดตเองทุกครั้งที่ FavoritesModel เปลี่ยน ไม่ว่าจะเปลี่ยนจากจุดไหน
                Text(' ${context.watch<FavoritesModel>().itemCount}'),
              ],
            ),
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
                labelText: 'ค้นหาสินค้า',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value); // ใช้ setState ตรงๆ ตามหลัก Ephemeral State
              },
            ),
          ),
          Expanded(
            child: ItemListSection(catalog: filteredCatalog),
          ),
        ],
      ),
    );
  }
}
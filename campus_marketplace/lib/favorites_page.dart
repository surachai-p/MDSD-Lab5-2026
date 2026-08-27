import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/favorites_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // .watch เพราะหน้านี้ต้อง rebuild ทุกครั้งที่รายการโปรดเปลี่ยน (เช่น กดลบจากหน้านี้เอง)
    final favorites = context.watch<FavoritesModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการโปรดของฉัน'),
        actions: [
          // ปุ่มนี้โผล่เฉพาะตอนมีรายการโปรดอย่างน้อย 1 ชิ้น
          if (favorites.items.isNotEmpty)
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
                        // .read เพราะเป็นการกดปุ่มยืนยันครั้งเดียวเพื่อสั่งงาน ไม่ใช่การอ่านค่าต่อเนื่อง
                        context.read<FavoritesModel>().clear();
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
      body: favorites.items.isEmpty
          ? const Center(child: Text('ยังไม่มีสินค้าที่บันทึกไว้'))
          : ListView.builder(
              itemCount: favorites.items.length,
              itemBuilder: (context, index) {
                final item = favorites.items[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    // .read เพราะเป็นการกดปุ่มครั้งเดียว ไม่ใช่การอ่านค่าต่อเนื่องแบบ .watch
                    onPressed: () => context.read<FavoritesModel>().remove(item),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Text('มูลค่ารวม: ฿${favorites.totalValue.toStringAsFixed(0)}'),
      ),
    );
  }
}

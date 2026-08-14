import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/favorites_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesModel>();
    final items = favorites.favoriteItems; // <- Item object เต็ม ไม่ใช่ id

    return Scaffold(
      appBar: AppBar(title: const Text('รายการโปรดของฉัน'), actions: [
        if (items.isNotEmpty)
          IconButton(
            tooltip: 'ล้างรายการโปรดทั้งหมด',
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('ยืนยัน'),
                  content: const Text('คุณแน่ใจว่าจะล้างรายการโปรดทั้งหมดหรือไม่?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('ยกเลิก')),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('ลบ')),
                  ],
                ),
              );

              if (confirmed == true) {
                // ใช้ read สำหรับการกระทำครั้งเดียว ไม่ต้องการให้ widget rebuild โดยตรงจากที่นี่
                // ignore: use_build_context_synchronously
                context.read<FavoritesModel>().clear();
              }
            },
          ),
      ]),
      body: items.isEmpty
          ? const Center(child: Text('ยังไม่มีสินค้าที่บันทึกไว้'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        context.read<FavoritesModel>().remove(item.id), // <- ส่ง id (String)
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
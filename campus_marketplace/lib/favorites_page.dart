import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/favorites_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('รายการโปรดของฉัน')),
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
                    onPressed: () =>
                        context.read<FavoritesModel>().remove(item),
                  ),
                );
              },
            ),
      bottomNavigationBar: favorites.items.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'มูลค่ารวม: ฿${favorites.totalValue.toStringAsFixed(0)}',
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('ล้างรายการโปรดทั้งหมด'),
                          content: const Text(
                            'คุณต้องการลบสินค้าทั้งหมดจากรายการโปรดใช่หรือไม่',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: const Text('ยกเลิก'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              child: const Text('ล้างข้อมูล'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        context.read<FavoritesModel>().clear();
                      }
                    },
                    child: const Text('ล้างทั้งหมด'),
                  ),
                ],
              ),
            ),
    );
  }
}

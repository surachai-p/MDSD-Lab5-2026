import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favorites_notifier.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(favoritesProvider);
    final total = ref.watch(favoritesProvider.notifier).totalValue;

    return Scaffold(
      appBar: AppBar(title: const Text('รายการโปรดของฉัน'), actions: [
        if (items.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'ล้างรายการโปรดทั้งหมด',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('ยืนยัน'),
                  content: const Text('คุณแน่ใจว่าจะล้างรายการโปรดทั้งหมดหรือไม่?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('ยกเลิก')),
                    TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('ลบ')),
                  ],
                ),
              );

              if (confirmed == true) {
                // ใช้ read เพื่อเรียก action หนึ่งครั้ง
                ref.read(favoritesProvider.notifier).clear();
              }
            },
          )
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
                    onPressed: () => ref.read(favoritesProvider.notifier).remove(item),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Text('มูลค่ารวม: ฿${total.toStringAsFixed(0)}'),
      ),
    );
  }
}

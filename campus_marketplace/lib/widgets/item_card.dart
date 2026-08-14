import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../models/favorites_model.dart';

class ItemCard extends StatelessWidget {
  final Item item; // เหลือแค่พารามิเตอร์ข้อมูล Item ชิ้นนี้ชิ้นเดียว

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // .watch สั่งให้ Rebuild เฉพาะเมื่อข้อมูล FavoritesModel มีการเปลี่ยนแปลง
    final favorites = context.watch<FavoritesModel>();
    final alreadySaved = favorites.items.any((i) => i.id == item.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(item.title),
        subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
        trailing: ElevatedButton(
          onPressed: alreadySaved
              ? null
              : () {
                  // .read ใช้เรียก Action โดยไม่ต้องคอย Rebuild ทั้ง Widget
                  context.read<FavoritesModel>().add(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('บันทึก ${item.title} ไว้ในรายการโปรดแล้ว'),
                    ),
                  );
                },
          child: Text(
            alreadySaved ? '❤️ บันทึกแล้ว' : '🤍 บันทึกเป็นรายการโปรด',
          ),
        ),
      ),
    );
  }
}

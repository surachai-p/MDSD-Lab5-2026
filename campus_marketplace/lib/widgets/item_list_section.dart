import 'package:flutter/material.dart';
import '../models/item.dart';
import 'item_card.dart';

class ItemListSection extends StatelessWidget {
  final List<Item> items;

  // ตัด savedItems และ onSave ออกจาก Constructor ได้ทั้งหมด!
  const ItemListSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        // ส่งเฉพาะ item ข้อมูลตัวมันเองไปให้ ItemCard
        return ItemCard(item: items[index]);
      },
    );
  }
}
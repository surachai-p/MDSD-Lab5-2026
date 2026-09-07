import 'package:flutter/material.dart';

import '../models/item.dart';
import 'item_card.dart';

class ItemListSection extends StatelessWidget {
  final List<Item> catalog;

  const ItemListSection({super.key, required this.catalog});

  @override
  Widget build(BuildContext context) {
    if (catalog.isEmpty) {
      return const Center(child: Text('ไม่พบสินค้าที่ค้นหา'));
    }

    return ListView.builder(
      itemCount: catalog.length,
      itemBuilder: (context, index) => ItemCard(item: catalog[index]),
    );
  }
}

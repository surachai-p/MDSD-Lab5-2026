import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favorites_model.dart';
import '../models/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesModel>();
    final alreadySaved = favorites.contains(item);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(item.title),
        subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
        trailing: ElevatedButton.icon(
          icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border),
          onPressed: alreadySaved
              ? null
              : () {
                  context.read<FavoritesModel>().add(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('บันทึก ${item.title} แล้ว')),
                  );
                },
          label: Text(alreadySaved ? 'บันทึกแล้ว' : 'บันทึก'),
        ),
      ),
    );
  }
}

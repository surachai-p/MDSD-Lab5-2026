import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/item.dart';
import 'models/favorites_model.dart';
import 'widgets/item_list_section.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesModel>();
    final filteredCatalog = catalog.where((item) {
      final normalizedQuery = _query.trim().toLowerCase();
      if (normalizedQuery.isEmpty) return true;
      return item.title.toLowerCase().contains(normalizedQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Marketplace'),
        actions: [
          IconButton(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite),
                Text(' ${favorites.itemCount}'),
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
                hintText: 'ค้นหาสินค้า',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(child: ItemListSection(catalog: filteredCatalog)),
        ],
      ),
    );
  }
}

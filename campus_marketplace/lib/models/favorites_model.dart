import 'package:flutter/material.dart';
import 'item.dart';

class FavoritesModel extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  List<Item> get favoriteItems =>
      catalog.where((item) => _items.contains(item.id)).toList();

  double get totalValue =>
      favoriteItems.fold(0, (sum, item) => sum + item.price);

  void add(String id) {
    if (!_items.contains(id)) {
      _items.add(id);
      notifyListeners();
    }
  }

  void remove(String id) {
    if (_items.remove(id)) {
      notifyListeners();
    }
  }

  bool contains(String id) => _items.contains(id);

  void clear() {}
}
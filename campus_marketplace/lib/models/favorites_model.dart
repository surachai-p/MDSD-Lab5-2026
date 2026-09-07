import 'package:flutter/foundation.dart';

import 'item.dart';

class FavoritesModel extends ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  double get totalValue => _items.fold(0, (sum, item) => sum + item.price);

  bool contains(Item item) => _items.any((saved) => saved.id == item.id);

  void add(Item item) {
    if (contains(item)) return;
    _items.add(item);
    notifyListeners();
  }

  void remove(Item item) {
    _items.removeWhere((saved) => saved.id == item.id);
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}

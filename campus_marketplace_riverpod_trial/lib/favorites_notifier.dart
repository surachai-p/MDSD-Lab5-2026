import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'item.dart';

class FavoritesNotifier extends StateNotifier<List<Item>> {
  FavoritesNotifier() : super([]);

  void add(Item item) {
    if (state.any((saved) => saved.id == item.id)) return;
    state = [...state, item];
  }

  void remove(Item item) {
    state = state.where((saved) => saved.id != item.id).toList();
  }

  void clear() {
    state = [];
  }

  double get totalValue => state.fold(0, (sum, item) => sum + item.price);
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Item>>(
  (ref) => FavoritesNotifier(),
);

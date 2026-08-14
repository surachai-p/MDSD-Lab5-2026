import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'item.dart';

class FavoritesNotifier extends StateNotifier<List<Item>> {
  FavoritesNotifier() : super([]);

  void add(Item item) => state = [...state, item];

  void remove(Item item) =>
      state = state.where((i) => i.id != item.id).toList();

  double get totalValue => state.fold(0, (sum, i) => sum + i.price);
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Item>>(
  (ref) => FavoritesNotifier(),
);

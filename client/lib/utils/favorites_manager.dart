import 'package:flutter/material.dart';
import 'package:client/utils/request_manager.dart';

class FavoritesManager with ChangeNotifier {
  final ValueNotifier<Map<int, bool>> _favoritesNotifier = ValueNotifier({});
  final RequestManager requestManager =
      RequestManager(baseUrl: "http://172.18.0.3:5000");
  FavoritesManager();

  void notify() {
    notifyListeners();
  }

  Future<void> toggleFavorite(bool newStatus, String title, int id) async {
    newStatus = !newStatus;

    if (newStatus) {
      final result = await requestManager.addFavorite(title);

      if (result != null) {
        _favoritesNotifier.value = Map.from(_favoritesNotifier.value)
          ..[id] = newStatus;
        notifyListeners(); 
      }
    } else {
      final result = await requestManager.removeFavorite(title);
      if (result != null) {
        _favoritesNotifier.value = Map.from(_favoritesNotifier.value)
          ..[id] = newStatus;
        notifyListeners(); 
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:client/utils/request_manager.dart';

class SeenMovieManager with ChangeNotifier {
  final ValueNotifier<Map<int, bool>> _seenMoviesNotifier = ValueNotifier({});
  final RequestManager requestManager =
      RequestManager(baseUrl: "http://172.18.0.3:5000");
  SeenMovieManager();

  void notify() {
    notifyListeners();
  }

  Future<void> togglesSeenMovies(bool newStatus, String title, int id) async {
    newStatus = !newStatus;

    if (newStatus) {
      final result = await requestManager.addSeenMovies(title);
      print('result: $result');
      if (result != null) {
        _seenMoviesNotifier.value = Map.from(_seenMoviesNotifier.value)
          ..[id] = newStatus;
        notifyListeners(); 
      }
    } else {
      final result = await requestManager.removeSeenMovies(title);
      if (result != null) {
        _seenMoviesNotifier.value = Map.from(_seenMoviesNotifier.value)
          ..[id] = newStatus;
        notifyListeners(); 
      }
    }
  }
}

import 'package:flutter/foundation.dart';

import '../models/location_model.dart';
import '../services/local_storage_service.dart';

class FavoriteViewModel extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();

  List<LocationModel> _favorites = [];
  bool _isLoading = false;

  List<LocationModel> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _storageService.getFavorites();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(LocationModel location) {
    return _favorites.any((item) => item.id == location.id);
  }

  Future<void> toggleFavorite(LocationModel location) async {
    final index = _favorites.indexWhere((item) => item.id == location.id);

    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(location);
    }

    notifyListeners();

    try {
      await _storageService.saveFavorites(_favorites);
    } catch (_) {
      // Jika penyimpanan gagal, muat ulang data terakhir.
      _favorites = await _storageService.getFavorites();
      notifyListeners();
      rethrow;
    }
  }
}

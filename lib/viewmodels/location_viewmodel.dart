import 'package:flutter/foundation.dart';

import '../models/location_model.dart';
import '../services/location_service.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  List<LocationModel> _locations = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<LocationModel> get locations => _locations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> searchLocations(String query) async {
    if (query.trim().isEmpty) {
      _locations = [];
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _locations = await _locationService.searchLocations(query);
    } catch (error) {
      _locations = [];
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _locations = [];
    _errorMessage = null;
    notifyListeners();
  }
}

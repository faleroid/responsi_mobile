import 'package:flutter/foundation.dart';

import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

import '../services/local_storage_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocalStorageService _storageService = LocalStorageService();

  WeatherModel? _weather;
  LocationModel? _selectedLocation;

  bool _isLoading = false;
  String? _errorMessage;

  WeatherModel? get weather => _weather;
  LocationModel? get selectedLocation => _selectedLocation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<LocationModel?> getLastLocation() {
    return _storageService.getLastLocation();
  }

  Future<void> fetchWeather(LocationModel location) async {
    _selectedLocation = location;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weather = await _weatherService.getWeather(location: location);

      try {
        await _storageService.saveLastLocation(location);
      } catch (error) {
        debugPrint('Gagal menyimpan lokasi terakhir: $error');
      }
    } catch (error) {
      _errorMessage = error.toString();
      _weather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearWeather() {
    _weather = null;
    _selectedLocation = null;
    _errorMessage = null;
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/location_model.dart';

class LocalStorageService {
  static const String _favoritesKey = 'favorite_locations';
  static const String _lastLocationKey = 'last_selected_location';

  Future<List<LocationModel>> getFavorites() async {
    final preferences = await SharedPreferences.getInstance();
    final data = preferences.getString(_favoritesKey);

    if (data == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(data) as List<dynamic>;

      return decoded
          .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFavorites(List<LocationModel> locations) async {
    final preferences = await SharedPreferences.getInstance();

    final data = jsonEncode(
      locations.map((location) => location.toJson()).toList(),
    );

    await preferences.setString(_favoritesKey, data);
  }

  Future<void> saveLastLocation(LocationModel location) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _lastLocationKey,
      jsonEncode(location.toJson()),
    );
  }

  Future<LocationModel?> getLastLocation() async {
    final preferences = await SharedPreferences.getInstance();
    final data = preferences.getString(_lastLocationKey);

    if (data == null) return null;

    try {
      return LocationModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}

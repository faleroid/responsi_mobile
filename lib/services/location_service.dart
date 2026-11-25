import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constant.dart';
import '../models/location_model.dart';

class LocationService {
  Future<List<LocationModel>> searchLocations(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final uri = Uri.parse(ApiConstants.geocodingBaseUrl).replace(
      queryParameters: {
        'name': query.trim(),
        'count': '10',
        'language': ApiConstants.language,
        'countryCode': ApiConstants.countryCode,
        'format': 'json',
      },
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;
      final results = json['results'] as List<dynamic>? ?? [];

      return results
          .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Gagal mencari lokasi. '
      'HTTP ${response.statusCode}: ${response.body}',
    );
  }
}

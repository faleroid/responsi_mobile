import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constant.dart';
import '../models/weather_model.dart';
import '../models/location_model.dart';

class WeatherService {
  Future<WeatherModel> getWeather({required LocationModel location}) async {
    final uri = Uri.parse(ApiConstants.weatherBaseUrl).replace(
      queryParameters: {
        'latitude': location.latitude.toString(),
        'longitude': location.longitude.toString(),
        'current': [
          'temperature_2m',
          'relative_humidity_2m',
          'apparent_temperature',
          'precipitation',
          'weather_code',
          'wind_speed_10m',
        ].join(','),
        'daily': [
          'weather_code',
          'temperature_2m_max',
          'temperature_2m_min',
          'precipitation_sum',
          'precipitation_probability_max',
          'wind_speed_10m_max',
        ].join(','),
        'forecast_days': ApiConstants.forecastDays.toString(),
        'timezone': ApiConstants.timezone,
      },
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      return WeatherModel.fromJson(json);
    }

    throw Exception(
      'Failed to fetch weather data. '
      'HTTP ${response.statusCode}: ${response.body}',
    );
  }
}

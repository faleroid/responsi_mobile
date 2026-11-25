import 'package:flutter/material.dart';

import '../../core/utils/weather_code_helper.dart';
import '../../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final String cityName;
  final WeatherModel weather;

  const CurrentWeatherCard({
    super.key,
    required this.cityName,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3978D5), Color(0xFF70B7E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            cityName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            WeatherCodeHelper.icon(weather.weatherCode),
            color: Colors.white,
            size: 76,
          ),
          const SizedBox(height: 12),
          Text(
            '${weather.temperature.round()}°C',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            WeatherCodeHelper.description(weather.weatherCode),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

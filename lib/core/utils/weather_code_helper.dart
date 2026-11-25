import 'package:flutter/material.dart';

class WeatherCodeHelper {
  static String description(int code) {
    if (code == 0) return 'Cerah';
    if (code <= 2) return 'Cerah Berawan';
    if (code == 3) return 'Berawan';
    if (code == 45 || code == 48) return 'Berkabut';
    if (code >= 51 && code <= 57) return 'Gerimis';
    if (code >= 61 && code <= 67) return 'Hujan';
    if (code >= 71 && code <= 77) return 'Salju';
    if (code >= 80 && code <= 82) return 'Hujan Lebat';
    if (code >= 85 && code <= 86) return 'Hujan Salju';
    if (code >= 95) return 'Badai Petir';

    return 'Tidak diketahui';
  }

  static IconData icon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 2) return Icons.cloud_queue;
    if (code == 3) return Icons.cloud;
    if (code == 45 || code == 48) return Icons.cloud_outlined;
    if (code >= 51 && code <= 67) return Icons.water_drop;
    if (code >= 71 && code <= 86) return Icons.ac_unit;
    if (code >= 95) return Icons.thunderstorm;

    return Icons.cloud_outlined;
  }
}

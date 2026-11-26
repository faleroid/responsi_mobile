import 'package:material_ui/material_ui.dart';

import '../../core/utils/weather_code_helper.dart';
import '../../models/forecast_model.dart';

class ForecastTile extends StatelessWidget {
  final ForecastModel forecast;

  const ForecastTile({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    const weekdays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];

    final dayName = weekdays[forecast.date.weekday - 1];

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          WeatherCodeHelper.icon(forecast.weatherCode),
          color: Colors.blue,
          size: 30,
        ),
        title: Text(dayName),
        subtitle: Text(WeatherCodeHelper.description(forecast.weatherCode)),
        trailing: Text(
          '${forecast.temperatureMax.round()}°-'
          '${forecast.temperatureMin.round()}°',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}

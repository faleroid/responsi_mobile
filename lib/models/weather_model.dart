import 'forecast_model.dart';

class WeatherModel {
  final double latitude;
  final double longitude;
  final String timezone;
  final double temperature;
  final int humidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  final List<ForecastModel> forecasts;

  WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.temperature,
    required this.humidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.forecasts,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    final dates = List<String>.from(daily['time'] as List);
    final weatherCodes = List<dynamic>.from(daily['weather_code'] as List);
    final temperatureMax = List<dynamic>.from(
      daily['temperature_2m_max'] as List,
    );
    final temperatureMin = List<dynamic>.from(
      daily['temperature_2m_min'] as List,
    );
    final precipitation = List<dynamic>.from(
      daily['precipitation_sum'] as List,
    );
    final precipitationProbability = List<dynamic>.from(
      daily['precipitation_probability_max'] as List,
    );
    final windSpeed = List<dynamic>.from(daily['wind_speed_10m_max'] as List);

    final forecasts = List.generate(dates.length, (index) {
      return ForecastModel.fromJson({
        'date': dates[index],
        'weather_code': weatherCodes[index],
        'temperature_2m_max': temperatureMax[index],
        'temperature_2m_min': temperatureMin[index],
        'precipitation_sum': precipitation[index],
        'precipitation_probability_max': precipitationProbability[index],
        'wind_speed_10m_max': windSpeed[index],
      });
    });

    return WeatherModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] as String,
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      apparentTemperature: (current['apparent_temperature'] as num).toDouble(),
      precipitation: (current['precipitation'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      forecasts: forecasts,
    );
  }
}

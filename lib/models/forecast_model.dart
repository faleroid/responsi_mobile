class ForecastModel {
  final DateTime date;
  final int weatherCode;
  final double temperatureMax;
  final double temperatureMin;
  final double precipitationSum;
  final int? precipitationProbability;
  final double? windSpeedMax;

  ForecastModel({
    required this.date,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationSum,
    this.precipitationProbability,
    this.windSpeedMax,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      date: DateTime.parse(json['date'] as String),
      weatherCode: (json['weather_code'] as num).toInt(),
      temperatureMax: (json['temperature_2m_max'] as num).toDouble(),
      temperatureMin: (json['temperature_2m_min'] as num).toDouble(),
      precipitationSum: (json['precipitation_sum'] as num).toDouble(),
      precipitationProbability: (json['precipitation_probability_max'] as num?)
          ?.toInt(),
      windSpeedMax: (json['wind_speed_10m_max'] as num?)?.toDouble(),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../models/weather_model.dart';
import '../../viewmodels/weather_viewmodel.dart';
import 'current_weather_card.dart';
import 'forecast_tile.dart';
import 'weather_detail_card.dart';

class WeatherContent extends StatelessWidget {
  final WeatherModel weather;
  final String cityName;
  final String fullAddress;

  const WeatherContent({
    super.key,
    required this.weather,
    required this.cityName,
    required this.fullAddress,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final viewModel = context.read<WeatherViewModel>();
        final location = viewModel.selectedLocation;

        if (location != null) {
          await viewModel.fetchWeather(location);
        }
      },
      child: ListView(
        children: [
          Align(
            alignment: Alignment.center, // atau Alignment.centerLeft
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color.fromARGB(39, 193, 193, 193),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Text(
                fullAddress,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),

          CurrentWeatherCard(cityName: cityName, weather: weather),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              WeatherDetailCard(
                icon: Icons.thermostat,
                title: 'Terasa Seperti',
                value: '${weather.apparentTemperature.round()}°C',
              ),
              WeatherDetailCard(
                icon: Icons.water_drop_outlined,
                title: 'Kelembapan',
                value: '${weather.humidity}%',
              ),
              WeatherDetailCard(
                icon: Icons.grain,
                title: 'Curah Hujan',
                value: '${weather.precipitation} mm',
              ),
              WeatherDetailCard(
                icon: Icons.air,
                title: 'Kecepatan Angin',
                value: '${weather.windSpeed} km/jam',
              ),
            ],
          ),

          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              'Prakiraan Cuaca',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 12),

          ...weather.forecasts.map(
            (forecast) => ForecastTile(forecast: forecast),
          ),
        ],
      ),
    );
  }
}

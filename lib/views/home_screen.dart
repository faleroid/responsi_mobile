import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/location_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/common/error_view.dart';
import '../widgets/weather/weather_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFindingLocation = true;
  String? _locationError;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialWeather();
    });
  }

  Future<void> _loadInitialWeather() async {
    setState(() {
      _isFindingLocation = true;
      _locationError = null;
    });

    try {
      final locationViewModel = context.read<LocationViewModel>();

      await locationViewModel.searchLocations('Purwokerto');

      if (!mounted) return;

      final locations = locationViewModel.locations;

      if (locations.isEmpty) {
        setState(() {
          _locationError =
              locationViewModel.errorMessage ??
              'Lokasi Purwokerto tidak ditemukan.';
        });
        return;
      }

      final location = locations.firstWhere(
        (item) => item.name.toLowerCase() == 'purwokerto',
        orElse: () => locations.first,
      );

      await context.read<WeatherViewModel>().fetchWeather(location);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _locationError = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isFindingLocation = false;
        });
      }
    }
  }

  Future<void> _refreshWeather() async {
    final viewModel = context.read<WeatherViewModel>();
    final location = viewModel.selectedLocation;

    if (location == null) {
      await _loadInitialWeather();
    } else {
      await viewModel.fetchWeather(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _refreshWeather,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh cuaca',
          ),
        ],
      ),
      body: Consumer<WeatherViewModel>(
        builder: (context, viewModel, child) {
          if (_isFindingLocation || viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_locationError != null) {
            return ErrorView(
              message: _locationError!,
              onRetry: _loadInitialWeather,
            );
          }

          if (viewModel.errorMessage != null) {
            return ErrorView(
              message: viewModel.errorMessage!,
              onRetry: _refreshWeather,
            );
          }

          final weather = viewModel.weather;
          final location = viewModel.selectedLocation;

          if (weather == null || location == null) {
            return ErrorView(
              message: 'Data cuaca belum tersedia.',
              onRetry: _loadInitialWeather,
            );
          }

          return WeatherContent(
            weather: weather,
            cityName: location.name,
            fullAddress: location.fullAddress,
          );
        },
      ),
    );
  }
}

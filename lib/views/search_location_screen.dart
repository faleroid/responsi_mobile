import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location_model.dart';
import '../viewmodels/location_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/location/location_result_tile.dart';

import '../viewmodels/favorite_viewmodel.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _hasSearched = false;
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationViewModel>().clearSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchLocations() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nama kota terlebih dahulu.')),
      );
      return;
    }

    setState(() {
      _hasSearched = true;
    });

    await context.read<LocationViewModel>().searchLocations(query);
  }

  Future<void> _selectLocation(LocationModel location) async {
    setState(() {
      _isSelecting = true;
    });

    await context.read<WeatherViewModel>().fetchWeather(location);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cari Lokasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searchLocations(),
              decoration: InputDecoration(
                hintText: 'Contoh: Jakarta, Bandung, Yogyakarta',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _searchLocations,
                  icon: const Icon(Icons.arrow_forward),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Consumer<LocationViewModel>(
                builder: (context, viewModel, child) {
                  if (_isSelecting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.errorMessage != null) {
                    return Center(
                      child: Text(
                        viewModel.errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (viewModel.locations.isEmpty) {
                    return Center(
                      child: Text(
                        _hasSearched
                            ? 'Lokasi tidak ditemukan.'
                            : 'Cari kota untuk melihat informasi cuacanya.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: viewModel.locations.length,
                    itemBuilder: (context, index) {
                      final location = viewModel.locations[index];

                      return Consumer<FavoriteViewModel>(
                        builder: (context, favoriteViewModel, child) {
                          final isFavorite = favoriteViewModel.isFavorite(
                            location,
                          );

                          return LocationResultTile(
                            location: location,
                            isFavorite: isFavorite,
                            onTap: () => _selectLocation(location),
                            onFavoriteTap: () async {
                              try {
                                await favoriteViewModel.toggleFavorite(
                                  location,
                                );
                              } catch (error) {
                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Gagal menyimpan perubahan favorit.',
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

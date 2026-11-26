import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../viewmodels/favorite_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lokasi Favorit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<FavoriteViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.favorites.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada lokasi favorit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tambahkan kota melalui halaman pencarian.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.favorites.length,
            itemBuilder: (context, index) {
              final location = viewModel.favorites[index];

              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.location_on_outlined),
                  ),
                  title: Text(
                    location.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(location.fullAddress),
                  onTap: () async {
                    await context.read<WeatherViewModel>().fetchWeather(
                      location,
                    );

                    if (!context.mounted) return;

                    Navigator.pop(context);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    tooltip: 'Hapus dari favorit',
                    onPressed: () async {
                      try {
                        await viewModel.toggleFavorite(location);
                      } catch (_) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal mengubah lokasi favorit.'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

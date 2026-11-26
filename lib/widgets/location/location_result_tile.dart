import 'package:material_ui/material_ui.dart';

import '../../models/location_model.dart';

class LocationResultTile extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const LocationResultTile({
    super.key,
    required this.location,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.location_on_outlined)),
        title: Text(
          location.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(location.fullAddress),
        onTap: onTap,
        trailing: IconButton(
          onPressed: onFavoriteTap,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambahkan ke favorit',
        ),
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'viewmodels/weather_viewmodel.dart';
import 'viewmodels/location_viewmodel.dart';
import 'views/home_screen.dart';

import 'viewmodels/favorite_viewmodel.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
        ChangeNotifierProvider(create: (_) => LocationViewModel()),
        ChangeNotifierProvider(
          create: (_) => FavoriteViewModel()..loadFavorites(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3978D5)),
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/screens/widgets/info_item.dart';
import 'package:weather_app/screens/widgets/forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Future<Map<String, dynamic>> _weatherData;

  @override
  void initState() {
    super.initState();
    _weatherData = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    String city = 'Bucharest';

    var url = Uri.http('api.openweathermap.org', '/data/2.5/forecast', {
      'q': city,
      'APPID': openWeatherAPIKey,
      'units': 'metric',
    });

    try {
      final res = await http.get(url);
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'Error fetching weather data';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  IconData getWeatherIcon(String condition) {
    switch (condition) {
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.waves;
      case 'Clear':
        return Icons.wb_sunny;
      default:
        return Icons.cloud_queue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _weatherData = getCurrentWeather();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final data = snapshot.data!;
          final currentData = data['list'][0];
          final currentTemp = currentData['main']['temp'];
          final currentSky = currentData['weather'][0]['main'];
          final currentPressure = currentData['main']['pressure'];
          final currentHumidity = currentData['main']['humidity'];
          final currentWindSpeed = currentData['wind']['speed'];
          final forecastItems = data['list'].sublist(1);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp °C',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                getWeatherIcon(currentSky),
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Weather forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: forecastItems.length,
                    itemBuilder: (ctx, i) {
                      final item = forecastItems[i];
                      final IconData icon =
                          getWeatherIcon(item['weather'][0]['main']);
                      final String time =
                          DateFormat.j().format(DateTime.parse(item['dt_txt']));
                      final temp = '${item['main']['temp']} °C';
                      return ForecastItem(
                        icon: icon,
                        time: time,
                        temperature: temp,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InfoItem(
                      title: 'Humidity',
                      icon: Icons.water_drop_sharp,
                      value: '$currentHumidity',
                    ),
                    InfoItem(
                      title: 'Wind Speed',
                      icon: Icons.air,
                      value: '$currentWindSpeed',
                    ),
                    InfoItem(
                      title: 'Pressure',
                      icon: Icons.umbrella,
                      value: '$currentPressure',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

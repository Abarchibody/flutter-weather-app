import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/screens/widgets/info_item.dart';
import 'package:weather_app/screens/widgets/forcast_item.dart';
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
  double temp = 0;

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
        throw 'getCurrentWeather Error';
      }
      return data;
      // temp = data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
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
              getCurrentWeather();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;

          final currentData = data['list'][0];

          final currentTemp = currentData['main']['temp'];
          final currentSky = currentData['weather'][0]['main'];

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
                                currentSky == "Clouds"
                                    ? Icons.cloud
                                    : currentSky == "Rain"
                                        ? Icons.waves
                                        : currentSky == "Clear"
                                            ? Icons.wb_sunny
                                            : Icons.cloud_queue,
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
                  "Weather forcast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ForcastItem(
                        icon: Icons.cloud,
                        time: "10:00",
                        temperature: "28°C",
                      ),
                      ForcastItem(
                        icon: Icons.cloud,
                        time: "11:00",
                        temperature: "28°C",
                      ),
                      ForcastItem(
                        icon: Icons.cloud,
                        time: "12:00",
                        temperature: "29°C",
                      ),
                      ForcastItem(
                        icon: Icons.cloud,
                        time: "13:00",
                        temperature: "30°C",
                      ),
                      ForcastItem(
                        icon: Icons.cloud,
                        time: "14:00",
                        temperature: "30°C",
                      )
                    ],
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InfoItem(
                      title: 'Himidity',
                      icon: Icons.water_drop_sharp,
                      value: '94',
                    ),
                    InfoItem(
                      title: 'Wind Speed',
                      icon: Icons.air,
                      value: '7.67',
                    ),
                    InfoItem(
                      title: 'Pressure',
                      icon: Icons.umbrella,
                      value: '1006',
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

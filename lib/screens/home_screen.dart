import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/screens/widgets/info_item.dart';
import 'package:weather_app/screens/widgets/forcast_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
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
              // Add code here
            },
          ),
        ],
      ),
      body: Padding(
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
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '30°C',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Icon(
                            Icons.cloud,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Rain',
                            style: TextStyle(
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
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'data/stations.dart';
import 'domain/target_station_resolver.dart';
import 'service/location_service.dart';

void main() {
  runApp(const OniwaStationApp());
}

class OniwaStationApp extends StatelessWidget {
  const OniwaStationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '大庭駅専用時刻表',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _locationService = LocationService();
  Station? _targetStation;
  bool _loading = true;
  bool _locationAcquired = false;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    final position = await _locationService.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      _targetStation = resolveTargetStation(
        latitude: position?.latitude,
        longitude: position?.longitude,
      );
      _locationAcquired = position != null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('大庭駅専用時刻表'),
      ),
      body: Center(
        child: _loading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('位置情報を取得中...'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '対象駅: ${_targetStation!.name}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _locationAcquired ? '位置情報: 取得成功' : '位置情報: 取得不可',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
      ),
    );
  }
}

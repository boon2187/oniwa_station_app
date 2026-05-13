import 'package:flutter/material.dart';

import '../data/stations.dart';
import '../data/train_schedule.dart';
import '../domain/target_station_resolver.dart';
import '../domain/train_finder.dart';
import '../service/location_service.dart';

class CurrentStatusScreen extends StatefulWidget {
  const CurrentStatusScreen({super.key});

  @override
  State<CurrentStatusScreen> createState() => _CurrentStatusScreenState();
}

class _CurrentStatusScreenState extends State<CurrentStatusScreen> {
  final _locationService = LocationService();
  bool _loading = true;
  Station? _targetStation;
  bool _locationAcquired = false;
  TrainSchedule? _currentTrain;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final position = await _locationService.getCurrentPosition();
    if (!mounted) return;
    final targetStation = resolveTargetStation(
      latitude: position?.latitude,
      longitude: position?.longitude,
    );
    final schedule = _scheduleFor(targetStation);
    final train = findNextTrain(schedule, DateTime.now());
    setState(() {
      _targetStation = targetStation;
      _locationAcquired = position != null;
      _currentTrain = train;
      _loading = false;
    });
  }

  List<TrainSchedule> _scheduleFor(Station origin) {
    return origin == Station.oniwa ? oniwaToMatsumoto : matsumotoToOniwa;
  }

  Station _destinationFor(Station origin) {
    return origin == Station.oniwa ? Station.matsumoto : Station.oniwa;
  }

  void _showNextTrain() {
    final target = _targetStation;
    final current = _currentTrain;
    if (target == null || current == null) return;
    final next = findTrainAfter(_scheduleFor(target), current);
    if (next == null) return;
    setState(() => _currentTrain = next);
  }

  bool _hasNextTrain() {
    final target = _targetStation;
    final current = _currentTrain;
    if (target == null || current == null) return false;
    return findTrainAfter(_scheduleFor(target), current) != null;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('位置情報を取得中...'),
          ],
        ),
      );
    }

    final theme = Theme.of(context);
    final target = _targetStation!;
    final current = _currentTrain;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${target.name}駅', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 32),
                if (current == null)
                  Text(
                    '本日の運行は終了しました',
                    style: theme.textTheme.titleLarge,
                  )
                else ...[
                  Text(
                    '${current.departure} 発',
                    style: theme.textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.arrow_downward, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '${_destinationFor(target).name}駅 ${current.arrival} 着',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: _hasNextTrain() ? _showNextTrain : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('次の電車'),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (!_locationAcquired)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '位置情報を取得できませんでした。大庭駅を表示しています',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/train_schedule.dart';
import '../domain/train_finder.dart';

class ArrivalDeadlineScreen extends StatefulWidget {
  const ArrivalDeadlineScreen({
    super.key,
    required this.title,
    required this.schedule,
    required this.originStationName,
    required this.destinationStationName,
  });

  final String title;
  final List<TrainSchedule> schedule;
  final String originStationName;
  final String destinationStationName;

  @override
  State<ArrivalDeadlineScreen> createState() => _ArrivalDeadlineScreenState();
}

class _ArrivalDeadlineScreenState extends State<ArrivalDeadlineScreen> {
  late int _selectedHour;
  late int _selectedMinute;
  bool _hasSet = false;
  TrainSchedule? _currentTrain;

  @override
  void initState() {
    super.initState();
    final initial = roundUpToHalfHour(DateTime.now());
    _selectedHour = initial.hour;
    _selectedMinute = initial.minute;
  }

  Future<void> _openPicker() async {
    int tempHour = _selectedHour;
    int tempMinute = _selectedMinute;
    final result = await showModalBottomSheet<({int hour, int minute})>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: 320,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(
                        (hour: tempHour, minute: tempMinute),
                      ),
                      child: const Text('完了'),
                    ),
                  ],
                ),
                Expanded(
                  child: StatefulBuilder(
                    builder: (ctx, setSheet) {
                      return Row(
                        children: [
                          Expanded(
                            child: CupertinoPicker(
                              itemExtent: 36,
                              scrollController: FixedExtentScrollController(
                                initialItem: tempHour,
                              ),
                              onSelectedItemChanged: (i) => tempHour = i,
                              children: [
                                for (var h = 0; h < 24; h++)
                                  Center(
                                    child: Text(
                                      '${h.toString().padLeft(2, '0')} 時',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (final m in const [0, 30])
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: ChoiceChip(
                                      label: Text(
                                        '${m.toString().padLeft(2, '0')} 分',
                                      ),
                                      selected: tempMinute == m,
                                      onSelected: (_) {
                                        setSheet(() => tempMinute = m);
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (result == null || !mounted) return;
    final today = DateTime.now();
    final deadline = DateTime(
      today.year,
      today.month,
      today.day,
      result.hour,
      result.minute,
    );
    setState(() {
      _selectedHour = result.hour;
      _selectedMinute = result.minute;
      _hasSet = true;
      _currentTrain = findLatestArrivalBy(widget.schedule, deadline);
    });
  }

  void _showNextTrain() {
    final current = _currentTrain;
    if (current == null) return;
    final next = findTrainAfter(widget.schedule, current);
    if (next == null) return;
    setState(() => _currentTrain = next);
  }

  bool _hasNextTrain() {
    final current = _currentTrain;
    if (current == null) return false;
    return findTrainAfter(widget.schedule, current) != null;
  }

  void _showPrevTrain() {
    final current = _currentTrain;
    if (current == null) return;
    final prev = findTrainBefore(widget.schedule, current);
    if (prev == null) return;
    setState(() => _currentTrain = prev);
  }

  bool _hasPrevTrain() {
    final current = _currentTrain;
    if (current == null) return false;
    return findTrainBefore(widget.schedule, current) != null;
  }

  String _formatTime(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = _currentTrain;
    final timeLabel =
        _hasSet ? _formatTime(_selectedHour, _selectedMinute) : '--:--';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: _openPicker,
            icon: const Icon(Icons.access_time),
            label: Text(
              timeLabel,
              style: theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 32),
          if (!_hasSet)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '希望時刻を設定してください',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            )
          else if (current == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'ご希望の時刻に間に合う電車はありません',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            Text(
              '${widget.originStationName}駅 ${current.departure} 発',
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            const Icon(Icons.arrow_downward, size: 32),
            const SizedBox(height: 8),
            Text(
              '${widget.destinationStationName}駅 ${current.arrival} 着',
              style: theme.textTheme.titleLarge,
            ),
          ],
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _hasNextTrain() ? _showNextTrain : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('次の電車'),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _hasPrevTrain() ? _showPrevTrain : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('前の電車'),
          ),
        ],
      ),
    );
  }
}

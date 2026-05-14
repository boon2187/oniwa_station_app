import 'package:flutter/material.dart';

import '../data/train_schedule.dart';
import 'arrival_deadline_screen.dart';

class ArriveAtMatsumotoScreen extends StatelessWidget {
  const ArriveAtMatsumotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ArrivalDeadlineScreen(
      title: '松本駅に到着したい時刻',
      schedule: oniwaToMatsumoto,
      originStationName: '大庭',
      destinationStationName: '松本',
    );
  }
}

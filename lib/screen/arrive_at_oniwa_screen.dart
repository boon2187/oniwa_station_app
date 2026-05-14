import 'package:flutter/material.dart';

import '../data/train_schedule.dart';
import 'arrival_deadline_screen.dart';

class ArriveAtOniwaScreen extends StatelessWidget {
  const ArriveAtOniwaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ArrivalDeadlineScreen(
      title: '大庭駅に到着したい時刻',
      schedule: matsumotoToOniwa,
      originStationName: '松本',
      destinationStationName: '大庭',
    );
  }
}

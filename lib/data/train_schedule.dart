/// 大庭駅(Oniwa)⇔松本駅(Matsumoto) 時刻表データ
///
/// データソース: timeTable.ods
/// 時刻形式: 'HH:mm' (24時間表記)

class TrainSchedule {
  /// 出発時刻 (HH:mm)
  final String departure;

  /// 到着時刻 (HH:mm)
  final String arrival;

  const TrainSchedule({
    required this.departure,
    required this.arrival,
  });
}

/// 大庭駅発 → 松本駅着
const List<TrainSchedule> oniwaToMatsumoto = [
  TrainSchedule(departure: '06:06', arrival: '06:14'),
  TrainSchedule(departure: '06:51', arrival: '06:59'),
  TrainSchedule(departure: '07:36', arrival: '07:44'),
  TrainSchedule(departure: '08:03', arrival: '08:11'),
  TrainSchedule(departure: '08:21', arrival: '08:31'),
  TrainSchedule(departure: '09:04', arrival: '09:12'),
  TrainSchedule(departure: '09:44', arrival: '09:51'),
  TrainSchedule(departure: '10:30', arrival: '10:37'),
  TrainSchedule(departure: '11:15', arrival: '11:22'),
  TrainSchedule(departure: '11:50', arrival: '11:57'),
  TrainSchedule(departure: '12:29', arrival: '12:36'),
  TrainSchedule(departure: '13:10', arrival: '13:17'),
  TrainSchedule(departure: '13:49', arrival: '13:56'),
  TrainSchedule(departure: '14:28', arrival: '14:35'),
  TrainSchedule(departure: '15:07', arrival: '15:14'),
  TrainSchedule(departure: '15:47', arrival: '15:55'),
  TrainSchedule(departure: '16:26', arrival: '16:33'),
  TrainSchedule(departure: '17:05', arrival: '17:13'),
  TrainSchedule(departure: '17:44', arrival: '17:51'),
  TrainSchedule(departure: '18:22', arrival: '18:29'),
  TrainSchedule(departure: '19:03', arrival: '19:10'),
  TrainSchedule(departure: '19:47', arrival: '19:54'),
  TrainSchedule(departure: '20:32', arrival: '20:39'),
  TrainSchedule(departure: '21:34', arrival: '21:41'),
  TrainSchedule(departure: '22:55', arrival: '23:02'),
];

/// 松本駅発 → 大庭駅着
const List<TrainSchedule> matsumotoToOniwa = [
  TrainSchedule(departure: '06:31', arrival: '06:37'),
  TrainSchedule(departure: '07:15', arrival: '07:21'),
  TrainSchedule(departure: '08:01', arrival: '08:07'),
  TrainSchedule(departure: '08:21', arrival: '08:27'),
  TrainSchedule(departure: '08:43', arrival: '08:49'),
  TrainSchedule(departure: '09:24', arrival: '09:30'),
  TrainSchedule(departure: '10:10', arrival: '10:16'),
  TrainSchedule(departure: '10:45', arrival: '10:51'),
  TrainSchedule(departure: '11:30', arrival: '11:36'),
  TrainSchedule(departure: '12:09', arrival: '12:15'),
  TrainSchedule(departure: '12:50', arrival: '12:56'),
  TrainSchedule(departure: '13:29', arrival: '13:35'),
  TrainSchedule(departure: '14:08', arrival: '14:14'),
  TrainSchedule(departure: '14:47', arrival: '14:53'),
  TrainSchedule(departure: '15:26', arrival: '15:36'),
  TrainSchedule(departure: '16:06', arrival: '16:12'),
  TrainSchedule(departure: '16:44', arrival: '16:50'),
  TrainSchedule(departure: '17:24', arrival: '17:30'),
  TrainSchedule(departure: '18:02', arrival: '18:08'),
  TrainSchedule(departure: '18:43', arrival: '18:49'),
  TrainSchedule(departure: '19:27', arrival: '19:33'),
  TrainSchedule(departure: '20:12', arrival: '20:18'),
  TrainSchedule(departure: '20:54', arrival: '21:00'),
  TrainSchedule(departure: '21:55', arrival: '22:01'),
  TrainSchedule(departure: '23:07', arrival: '23:13'),
];

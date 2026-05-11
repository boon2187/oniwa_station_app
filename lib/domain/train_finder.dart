import '../data/train_schedule.dart';

int _toMinutes(String hhmm) {
  final parts = hhmm.split(':');
  return int.parse(parts[0]) * 60 + int.parse(parts[1]);
}

int _dateTimeToMinutes(DateTime dt) => dt.hour * 60 + dt.minute;

/// 現在時刻 [now] 以降に発車する最初の電車を返す。
/// 全電車が過去なら null(=本日の運行は終了)。
/// 発車時刻ちょうどはまだ間に合う扱い。
TrainSchedule? findNextTrain(List<TrainSchedule> schedule, DateTime now) {
  final nowMin = _dateTimeToMinutes(now);
  for (final train in schedule) {
    if (_toMinutes(train.departure) >= nowMin) {
      return train;
    }
  }
  return null;
}

/// [deadline] までに到着できる電車のうち、現在時刻 [now] 以降に発車する最も遅い電車を返す。
/// 該当なしなら null。発車・到着時刻ちょうどはまだ間に合う扱い。
TrainSchedule? findLatestArrivalBy(
  List<TrainSchedule> schedule,
  DateTime deadline,
  DateTime now,
) {
  final deadlineMin = _dateTimeToMinutes(deadline);
  final nowMin = _dateTimeToMinutes(now);
  TrainSchedule? candidate;
  for (final train in schedule) {
    if (_toMinutes(train.departure) < nowMin) continue;
    if (_toMinutes(train.arrival) > deadlineMin) continue;
    candidate = train;
  }
  return candidate;
}

/// [current] の次の電車を返す。最終電車またはリスト外の電車を渡された場合は null。
/// 同一性は発車時刻で判定する。
TrainSchedule? findTrainAfter(
  List<TrainSchedule> schedule,
  TrainSchedule current,
) {
  final index = schedule.indexWhere((t) => t.departure == current.departure);
  if (index < 0 || index >= schedule.length - 1) return null;
  return schedule[index + 1];
}

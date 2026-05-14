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

/// [current] の前の電車を返す。始発またはリスト外の電車を渡された場合は null。
/// 同一性は発車時刻で判定する。
TrainSchedule? findTrainBefore(
  List<TrainSchedule> schedule,
  TrainSchedule current,
) {
  final index = schedule.indexWhere((t) => t.departure == current.departure);
  if (index <= 0) return null;
  return schedule[index - 1];
}

/// [now] 時点で [train] にまだ乗れる(発車していない)なら true。
/// 発車時刻ちょうどはまだ間に合う扱い。
bool isBoardable(TrainSchedule train, DateTime now) {
  return _toMinutes(train.departure) >= _dateTimeToMinutes(now);
}

/// [now] 以後で最も近い 00 分または 30 分の時刻を返す。
/// ちょうど 00 分 / 30 分の場合は [now] と同じ時刻(秒以下は切り捨て)。
/// 例: 15:37 → 16:00、15:10 → 15:30、15:00 → 15:00、23:31 → 翌日 00:00
DateTime roundUpToHalfHour(DateTime now) {
  if (now.minute == 0 || now.minute == 30) {
    return DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }
  if (now.minute < 30) {
    return DateTime(now.year, now.month, now.day, now.hour, 30);
  }
  final next = now.add(const Duration(hours: 1));
  return DateTime(next.year, next.month, next.day, next.hour, 0);
}

/// [now] 時点で、[schedule] の最終発車時刻を超えていれば true(本日の運行は終了)。
/// 最終発車時刻ちょうどはまだ false。空配列は true(=表示する電車なし)。
bool isAfterLastTrain(List<TrainSchedule> schedule, DateTime now) {
  if (schedule.isEmpty) return true;
  final lastMin = _toMinutes(schedule.last.departure);
  return _dateTimeToMinutes(now) > lastMin;
}

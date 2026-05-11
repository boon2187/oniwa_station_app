import 'package:flutter_test/flutter_test.dart';
import 'package:oniwa_station_app/data/train_schedule.dart';
import 'package:oniwa_station_app/domain/train_finder.dart';

const _fixture = [
  TrainSchedule(departure: '06:00', arrival: '06:10'),
  TrainSchedule(departure: '07:00', arrival: '07:10'),
  TrainSchedule(departure: '08:00', arrival: '08:10'),
  TrainSchedule(departure: '20:00', arrival: '20:10'),
];

DateTime _t(int hour, int minute) => DateTime(2026, 5, 11, hour, minute);

void main() {
  group('findNextTrain', () {
    test('始発前は始発を返す', () {
      expect(findNextTrain(_fixture, _t(5, 0))?.departure, '06:00');
    });

    test('発車時刻ちょうどは当該電車を返す', () {
      expect(findNextTrain(_fixture, _t(6, 0))?.departure, '06:00');
    });

    test('発車時刻の1分後は次の電車を返す', () {
      expect(findNextTrain(_fixture, _t(6, 1))?.departure, '07:00');
    });

    test('最終ジャストは最終を返す', () {
      expect(findNextTrain(_fixture, _t(20, 0))?.departure, '20:00');
    });

    test('最終の1分後は null(運行終了)', () {
      expect(findNextTrain(_fixture, _t(20, 1)), isNull);
    });

    test('深夜は null', () {
      expect(findNextTrain(_fixture, _t(23, 59)), isNull);
    });
  });

  group('findLatestArrivalBy', () {
    test('全電車が間に合うなら最終電車を返す', () {
      final result = findLatestArrivalBy(_fixture, _t(21, 0), _t(5, 0));
      expect(result?.departure, '20:00');
    });

    test('間に合う最も遅い電車を返す', () {
      // deadline 07:10 ちょうど → 07:00発(07:10着)は間に合う
      final result = findLatestArrivalBy(_fixture, _t(7, 10), _t(5, 0));
      expect(result?.departure, '07:00');
    });

    test('到着時刻が1分超過する電車は除外する', () {
      // deadline 07:09 → 07:00発(07:10着)は1分超過、よって06:00発が答え
      final result = findLatestArrivalBy(_fixture, _t(7, 9), _t(5, 0));
      expect(result?.departure, '06:00');
    });

    test('現在時刻時点で発車済みの電車は除外する', () {
      // 現在 06:30 / deadline 07:10 → 06:00発は除外、07:00発を返す
      final result = findLatestArrivalBy(_fixture, _t(7, 10), _t(6, 30));
      expect(result?.departure, '07:00');
    });

    test('間に合う電車が存在しないなら null', () {
      // deadline 05:00 → 始発が06:10着なので間に合わない
      final result = findLatestArrivalBy(_fixture, _t(5, 0), _t(4, 0));
      expect(result, isNull);
    });

    test('現在時刻が最終発車を過ぎていれば null', () {
      final result = findLatestArrivalBy(_fixture, _t(23, 0), _t(20, 1));
      expect(result, isNull);
    });
  });

  group('findTrainAfter', () {
    test('中盤の電車から次の電車を返す', () {
      final result = findTrainAfter(_fixture, _fixture[1]);
      expect(result?.departure, '08:00');
    });

    test('最終電車の次は null', () {
      final result = findTrainAfter(_fixture, _fixture.last);
      expect(result, isNull);
    });

    test('リストに存在しない電車を渡したら null', () {
      const stranger = TrainSchedule(departure: '12:34', arrival: '12:40');
      expect(findTrainAfter(_fixture, stranger), isNull);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:oniwa_station_app/data/stations.dart';
import 'package:oniwa_station_app/domain/target_station_resolver.dart';

void main() {
  group('resolveTargetStation', () {
    test('緯度経度が null なら大庭駅(フォールバック)', () {
      expect(
        resolveTargetStation(latitude: null, longitude: null),
        Station.oniwa,
      );
    });

    test('片方だけ null でも大庭駅(フォールバック)', () {
      expect(
        resolveTargetStation(latitude: 36.0, longitude: null),
        Station.oniwa,
      );
    });

    test('大庭駅のピンポイント座標なら大庭駅', () {
      expect(
        resolveTargetStation(
          latitude: Station.oniwa.latitude,
          longitude: Station.oniwa.longitude,
        ),
        Station.oniwa,
      );
    });

    test('松本駅のピンポイント座標なら松本駅', () {
      expect(
        resolveTargetStation(
          latitude: Station.matsumoto.latitude,
          longitude: Station.matsumoto.longitude,
        ),
        Station.matsumoto,
      );
    });

    test('大庭駅から北に約500m(500m閾値の境界内)なら大庭駅', () {
      // 緯度+0.0045度 ≒ 約500m北。閾値500m(<=)の境界内
      expect(
        resolveTargetStation(
          latitude: Station.oniwa.latitude + 0.0045,
          longitude: Station.oniwa.longitude,
        ),
        Station.oniwa,
      );
    });

    test('大庭駅から北に約400m(500m閾値内)なら大庭駅', () {
      expect(
        resolveTargetStation(
          latitude: Station.oniwa.latitude + 0.0036,
          longitude: Station.oniwa.longitude,
        ),
        Station.oniwa,
      );
    });

    test('大庭駅から北に約700m(500m閾値超・松本も1km超)なら大庭駅(フォールバック)', () {
      // 緯度+0.0063度 ≒ 約700m北。大庭は500m超、松本も1km超 → フォールバック
      expect(
        resolveTargetStation(
          latitude: Station.oniwa.latitude + 0.0063,
          longitude: Station.oniwa.longitude,
        ),
        Station.oniwa,
      );
    });

    test('松本駅から北に約500m(1km閾値内)なら松本駅', () {
      expect(
        resolveTargetStation(
          latitude: Station.matsumoto.latitude + 0.0045,
          longitude: Station.matsumoto.longitude,
        ),
        Station.matsumoto,
      );
    });

    test('松本駅から北に約900m(1km閾値内)なら松本駅', () {
      expect(
        resolveTargetStation(
          latitude: Station.matsumoto.latitude + 0.0081,
          longitude: Station.matsumoto.longitude,
        ),
        Station.matsumoto,
      );
    });

    test('松本駅から北に約1.2km(1km閾値超)なら大庭駅(フォールバック)', () {
      // 緯度+0.0108度 ≒ 約1.2km北。松本1km超かつ大庭からも遠い → フォールバック
      expect(
        resolveTargetStation(
          latitude: Station.matsumoto.latitude + 0.0108,
          longitude: Station.matsumoto.longitude,
        ),
        Station.oniwa,
      );
    });

    test('両駅から遠い場所(東京駅近辺)なら大庭駅(フォールバック)', () {
      expect(
        resolveTargetStation(latitude: 35.6812, longitude: 139.7671),
        Station.oniwa,
      );
    });

    test('両駅の中間点(両方とも閾値超)なら大庭駅(フォールバック)', () {
      final midLat = (Station.oniwa.latitude + Station.matsumoto.latitude) / 2;
      final midLon =
          (Station.oniwa.longitude + Station.matsumoto.longitude) / 2;
      expect(
        resolveTargetStation(latitude: midLat, longitude: midLon),
        Station.oniwa,
      );
    });
  });
}

import 'dart:math';

import '../data/stations.dart';

double _haversineMeters(double lat1, double lon1, double lat2, double lon2) {
  const earthRadius = 6371000.0;
  final dLat = (lat2 - lat1) * pi / 180;
  final dLon = (lon2 - lon1) * pi / 180;
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) *
          cos(lat2 * pi / 180) *
          sin(dLon / 2) *
          sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

/// 現在地の緯度経度から対象駅を判定する。
/// 大庭駅をフォールバックとし、以下の場合に大庭駅を返す:
/// - 緯度経度が null(GPS取得不可)
/// - 両駅とも [thresholdMeters] より遠い
/// - 大庭駅と松本駅から等距離
Station resolveTargetStation({
  required double? latitude,
  required double? longitude,
  double thresholdMeters = 1000,
}) {
  if (latitude == null || longitude == null) {
    return Station.oniwa;
  }
  final oniwaDistance = _haversineMeters(
    latitude,
    longitude,
    Station.oniwa.latitude,
    Station.oniwa.longitude,
  );
  final matsumotoDistance = _haversineMeters(
    latitude,
    longitude,
    Station.matsumoto.latitude,
    Station.matsumoto.longitude,
  );
  if (oniwaDistance > thresholdMeters && matsumotoDistance > thresholdMeters) {
    return Station.oniwa;
  }
  if (oniwaDistance <= matsumotoDistance) {
    return Station.oniwa;
  }
  return Station.matsumoto;
}

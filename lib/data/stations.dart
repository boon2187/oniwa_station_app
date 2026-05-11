/// 大庭駅・松本駅の定数。緯度経度は Google マップから取得。
library;

enum Station {
  oniwa(
    name: '大庭',
    latitude: 36.227052089138844,
    longitude: 137.94169730107538,
  ),
  matsumoto(
    name: '松本',
    latitude: 36.230786279333905,
    longitude: 137.96441015784512,
  );

  const Station({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;
}

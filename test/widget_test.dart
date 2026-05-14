import 'package:flutter_test/flutter_test.dart';

import 'package:oniwa_station_app/main.dart';

void main() {
  testWidgets('アプリ起動時にAppBar・ボトムナビ3タブ・ローディング表示が出る', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const OniwaStationApp());

    expect(find.text('ファミリー時刻表'), findsWidgets);
    expect(find.text('現在'), findsOneWidget);
    expect(find.text('松本着'), findsOneWidget);
    expect(find.text('大庭着'), findsOneWidget);
    expect(find.text('位置情報を取得中...'), findsOneWidget);
  });
}

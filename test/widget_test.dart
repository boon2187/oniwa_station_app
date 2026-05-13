import 'package:flutter_test/flutter_test.dart';

import 'package:oniwa_station_app/main.dart';

void main() {
  testWidgets('アプリ起動時にAppBarのタイトルとローディング表示が出る', (WidgetTester tester) async {
    await tester.pumpWidget(const OniwaStationApp());

    expect(find.text('大庭駅専用時刻表'), findsWidgets);
    expect(find.text('位置情報を取得中...'), findsOneWidget);
  });
}

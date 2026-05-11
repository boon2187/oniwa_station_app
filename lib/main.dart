import 'package:flutter/material.dart';

void main() {
  runApp(const OniwaStationApp());
}

class OniwaStationApp extends StatelessWidget {
  const OniwaStationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '大庭駅専用時刻表',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('大庭駅専用時刻表'),
      ),
      body: const Center(
        child: Text('準備中'),
      ),
    );
  }
}

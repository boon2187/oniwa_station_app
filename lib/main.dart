import 'package:flutter/material.dart';

import 'screen/arrive_at_matsumoto_screen.dart';
import 'screen/arrive_at_oniwa_screen.dart';
import 'screen/current_status_screen.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const _screens = [
    CurrentStatusScreen(),
    ArriveAtMatsumotoScreen(),
    ArriveAtOniwaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('大庭駅専用時刻表'),
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.access_time), label: '現在'),
          NavigationDestination(icon: Icon(Icons.flag), label: '松本着'),
          NavigationDestination(icon: Icon(Icons.home), label: '大庭着'),
        ],
      ),
    );
  }
}

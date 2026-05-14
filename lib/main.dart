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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final GlobalKey<CurrentStatusScreenState> _currentStatusKey =
      GlobalKey<CurrentStatusScreenState>();

  late final List<Widget> _screens = [
    CurrentStatusScreen(key: _currentStatusKey),
    const ArriveAtMatsumotoScreen(),
    const ArriveAtOniwaScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _currentStatusKey.currentState?.refresh();
    }
  }

  void _onDestinationSelected(int i) {
    setState(() => _currentIndex = i);
    if (i == 0) {
      _currentStatusKey.currentState?.refresh();
    }
  }

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
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.access_time), label: '現在'),
          NavigationDestination(icon: Icon(Icons.flag), label: '松本着'),
          NavigationDestination(icon: Icon(Icons.home), label: '大庭着'),
        ],
      ),
    );
  }
}

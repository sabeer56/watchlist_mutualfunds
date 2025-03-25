// screens/dashboard.dart
import 'package:flutter/material.dart';
import 'package:khazana/MutualFund/FundPerformanceScreen.dart';
import 'package:khazana/MutualFund/WatchList.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    InvestmentScreen(),
    const WatchlistSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutual Fund Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Fund Performance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'My Watchlist',
          ),
        ],
      ),
    );
  }
}
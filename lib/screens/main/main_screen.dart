import 'package:flutter/material.dart';
import 'package:qr_master/screens/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/index.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final MainTabsService _tabsService = MainTabsService();

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScanScreen(),
    const CreateQrScreen(),
    const HistoryScreen(),
    const MyQrCodesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabsService.setTabChangeCallback(_onTabChanged);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTabChanged(int index) {
    _onItemTapped(index);
  }

  BottomNavItem _getBottomNavItem(int index) {
    switch (index) {
      case 0:
        return BottomNavItem.home;
      case 1:
        return BottomNavItem.scan;
      case 2:
        return BottomNavItem.create;
      case 3:
        return BottomNavItem.history;
      case 4:
        return BottomNavItem.settings;
      default:
        return BottomNavItem.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: IndexedStack(
          key: ValueKey<int>(_selectedIndex),
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomTabsNavigator(
        currentItem: _getBottomNavItem(_selectedIndex),
        onItemSelected: (item) {
          final index = _getIndexForBottomNavItem(item);
          _onItemTapped(index);
        },
        onFabTap: () {
          _onItemTapped(2);
        },
      ),
    );
  }

  int _getIndexForBottomNavItem(BottomNavItem item) {
    switch (item) {
      case BottomNavItem.home:
        return 0;
      case BottomNavItem.scan:
        return 1;
      case BottomNavItem.create:
        return 2;
      case BottomNavItem.history:
        return 3;
      case BottomNavItem.settings:
        return 4;
    }
  }
}

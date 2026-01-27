import 'package:qr_master/widgets/main_screen/bottom_tabs_navigator/nav_item.dart';

class MainTabsService {
  static final MainTabsService _instance = MainTabsService._internal();
  factory MainTabsService() => _instance;
  MainTabsService._internal();

  Function(int)? _onTabChanged;

  void setTabChangeCallback(Function(int) callback) {
    _onTabChanged = callback;
  }

  void switchToTab(int index) {
    _onTabChanged?.call(index);
  }

  void switchToTabItem(BottomNavItem item) {
    final index = _getIndexForBottomNavItem(item);
    switchToTab(index);
  }

  void switchToHome() => switchToTab(0);
  void switchToScan() => switchToTab(1);
  void switchToCreate() => switchToTab(2);
  void switchToHistory() => switchToTab(3);
  void switchToMyQrCodes() => switchToTab(4);

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

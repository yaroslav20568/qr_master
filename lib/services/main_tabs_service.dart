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

  void switchToHome() => switchToTab(0);
  void switchToScan() => switchToTab(1);
  void switchToCreate() => switchToTab(2);
  void switchToHistory() => switchToTab(3);
  void switchToMyQrCodes() => switchToTab(4);
}

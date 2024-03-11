class Utility {
  static int _uniqueIdStepper = 0;

  static String getNextId({String? prefix}) {
    int id = _uniqueIdStepper++;
    return '$prefix $id';
  }
}

enum DashboardBottomTab { home, accounts, settings }

DashboardBottomTab getDashboardBottomTabByIndex(int index) {
  switch (index) {
    case 0:
      return DashboardBottomTab.home;
    case 1:
      return DashboardBottomTab.accounts;
    case 2:
      return DashboardBottomTab.settings;
  }

  return DashboardBottomTab.home;
}

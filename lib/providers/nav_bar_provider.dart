import 'package:flutter/foundation.dart';

class NavItems extends ChangeNotifier {
  int selectedIndex = 0;
  get selectedNavIndex {
    return selectedIndex;
  }

  void changeNavIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

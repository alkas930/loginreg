import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool isloading = false;

  setloader() {
    isloading = true;
    notifyListeners();
  }

  hideloader() {
    isloading = true;
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:musicorum/api/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musicorum/constants/storage_keys.dart';

class AuthState extends ChangeNotifier {
  AuthState({this.rootNavigator});
  String token;
  User user;

  bool get isLoggedIn => token != null;
  bool get isUserLoaded => user != null;

  NavigatorState rootNavigator;

  int selectedBottomItem = 0;

  void login(String tk) {
    token = tk;
    notifyListeners();
  }

  void setUser(User usr) {
    user = usr;
    notifyListeners();
  }

  void logOut() {
    token = null;
    user = null;

    final storage = new FlutterSecureStorage();
    storage.delete(key: STORAGE_TOKEN_KEY);

    notifyListeners();
  }
}
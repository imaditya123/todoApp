import 'dart:convert';

import 'package:todo/index.dart';
// import 'package:todo/utils/models.dart';

class Credential with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String userName = "";

  bool get isLogin {
    if (userName == "")
      return false;
    else
      return true;
  }

  String get getUserName {
    if (userName == "")
      return "";
    else
      return userName.replaceAll(new RegExp('\W+'), '');
  }

  Future<void> storeUserData(String usr) async {
    userName = usr;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(userName));
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    var p = prefs.getKeys();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    
    final data = json.decode(prefs.getString('userData').toString());
    userName = data['userName'].toString();
    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    userName = "";
    notifyListeners();
  }
}

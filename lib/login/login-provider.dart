import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/index.dart';
import 'package:todo/login/login-model.dart';

class LoginProvider with ChangeNotifier {
  Future<BaseResponse> login(LoginModel login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: login.userName, password: login.password);
      return BaseResponse(message: "login Successful", isSuccess: true);
    } on FirebaseAuthException catch (e) {
      return BaseResponse(message: e.message.toString());
    } catch (e) {}
    return BaseResponse(message: "");
  }

  Future<BaseResponse> signup(LoginModel login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: login.userName, password: login.password);
      return BaseResponse(message: "Sign up Successful", isSuccess: true);
    } on FirebaseAuthException catch (e) {
      return BaseResponse(message: e.message.toString());
    } catch (e) {}
    return BaseResponse(message: "");
  }
}

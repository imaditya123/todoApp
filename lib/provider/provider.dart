import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/index.dart';
import 'package:todo/provider/task-model.dart';
import 'package:todo/user-utils/cred.dart';

class Manager with ChangeNotifier {
  Credential cred;
  Manager({required this.cred});
  List<TaskModel> tasks = [];
  int totaltask = 0;

  Stream<List<TaskModel>> get getData {
    final fire = FirebaseFirestore.instance.collection(cred.getUserName);

    return fire.snapshots().map((QuerySnapshot<Map<String, dynamic>> event) =>
        event
            .docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                TaskModel.fromJson(e))
            .toList());
  }

  Future<String> addTask(TaskModel task) async {
    try {
      final fire = FirebaseFirestore.instance.collection(cred.getUserName);
      fire.add(task.toJson());
      notifyListeners();
      return "Added";
    } catch (e) {}

    return "Not Added";
  }

  Future<String> editTask(TaskModel task) async {
    try {
      final fire = FirebaseFirestore.instance.collection(cred.getUserName);
      fire.doc(task.id).update(task.toJson());
      notifyListeners();
      return "Edited";
    } catch (e) {}

    return "Not Edited";
  }

  Future<String> delete(TaskModel task) async {
    try {
      final fire = FirebaseFirestore.instance.collection(cred.getUserName);
      fire.doc(task.id).delete();
      // fire.(task.toJson());
      notifyListeners();
      return "Deleted";
    } catch (e) {}

    return "Not Deleted";
  }
}

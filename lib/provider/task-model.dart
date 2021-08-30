import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final int timestamp;
  final List<String> list;
  final List<bool> isSelected;

  TaskModel(
      {required this.id,
      required this.title,
      required this.timestamp,
      required this.list,
      required this.isSelected});

  factory TaskModel.fromJson(
      QueryDocumentSnapshot<Map<String, dynamic>> parsedJson) {
    List<String> _list = [];
    List<bool> _isSelectedlist = [];
    for (var i = 0; i < parsedJson['list1'].length; i++) {
      _list.add(parsedJson['list1'][i]);
      _isSelectedlist.add(parsedJson['list2'][i]);
    }

    return TaskModel(
      id: parsedJson.id,
      title: parsedJson['title'].toString(),
      timestamp: parsedJson['time'].toInt(),
      list: _list,
      isSelected: _isSelectedlist,
    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = title;
    data['time'] = timestamp;
    data['list1'] = list;
    data['list2'] = isSelected;

    return data;
  }
}

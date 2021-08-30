import 'package:flutter/cupertino.dart';
import 'package:todo/index.dart';
import 'package:todo/utils/custom-textfield.dart';

class EditTask extends StatefulWidget {
  EditTask({Key? key, required this.task}) : super(key: key);
  final TaskModel task;

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TimeOfDay startTime = TimeOfDay.now();

  TextEditingController controller = TextEditingController();
  TextEditingController name = TextEditingController();
  changeStartTime(TimeOfDay time) {
    FocusScope.of(context).unfocus();
    startTime = time;
  }

  DateTime startDate = DateTime.now();
  changeStartDate(DateTime date) {
    FocusScope.of(context).unfocus();
    startDate = date;
  }

  List<String> list = [];
  List<bool> isSelected = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startDate = DateTime.fromMillisecondsSinceEpoch(widget.task.timestamp);
    startTime = TimeOfDay(hour: startDate.hour, minute: startDate.minute);
    name = TextEditingController(text: widget.task.title);
    isSelected = widget.task.isSelected;
    list=widget.task.list;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: AppBar().preferredSize.height,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFFDEDEDE)))),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(CupertinoIcons.back)),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Edit task",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    onPressed: () async {
                      if (name.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Enter Task Name")));
                        return;
                      }
                      if (list.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Add Task")));
                        return;
                      }

                      final manage =
                          Provider.of<Manager>(context, listen: false);

                      TaskModel task = TaskModel(
                        id: widget.task.id,
                        title: name.text,
                        timestamp: CommonWidgets.convertTimeOfDay(
                          startTime,
                          p: startDate,
                        ).millisecondsSinceEpoch,
                        list: list,
                        isSelected: isSelected,
                      );
                      if (!isLoading) {
                        isLoading = true;
                        final msg = await manage.editTask(task);
                        print(msg);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));
                        await Future.delayed(Duration(seconds: 2));
                        if (msg == "Edited") Navigator.pop(context);
                        isLoading = false;
                      }
                    },
                    icon: Icon(CupertinoIcons.check_mark),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      child: Text(
                        "Task Name",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    CustomTextField(hint: "Task Name...", controller: name),

                    CustomDatePicker(
                      text: "Pick Date",
                      minDate: DateTime.now(),
                      maxDate: DateTime.now().add(Duration(days: 365)),
                      startDate: startDate,
                      changeDate: changeStartDate,
                    ),
                    CustomTimePicker(
                      text: "Pick Time",
                      initialTime: TimeOfDay(hour: 0, minute: 0),
                      startTime: startTime,
                      changeTime: changeStartTime,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      child: Text(
                        "Tasks:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: list
                            .map(
                              (item) => Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(value: isSelected[list.indexOf(item) ], onChanged: (p){
                                    setState(() {
                                      isSelected[list.indexOf(item) ]=p??false;
                                    });
                                  }),
                                  Text(
                                    item,
                                    style: TextStyle(fontSize: 19),
                                  ),
                                  Expanded(child: Container()),
                                  IconButton(
                                    icon: Icon(CupertinoIcons.delete),
                                    onPressed: () {
                                      setState(() {
                                        isSelected.removeAt(list.indexOf(item));
                                        list.remove(item);
                                      });
                                    },
                                  )
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    //Add Button
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                              hint: "Type...", controller: controller),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            if (controller.text == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Type Something")));
                              return;
                            }
                            if (list.contains(controller.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Task Already Added")));
                              return;
                            }
                            setState(() {
                              list.add(controller.text);
                              isSelected.add(false);
                            });
                            controller.clear();
                          },
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: AppColor.cyan,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                  // children: [DisplayTile()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

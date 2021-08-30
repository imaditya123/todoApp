import 'package:flutter/cupertino.dart';
import 'package:todo/index.dart';
import 'package:todo/utils/custom-textfield.dart';

class AddTask extends StatefulWidget {
  AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
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
  bool isLoading = false;
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
                      "Add task",
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
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Add Task")));
                        return;
                      }
                      
                      final manage =
                          Provider.of<Manager>(context, listen: false);

                      TaskModel task = TaskModel(
                        id: "",
                        title: name.text,
                        timestamp: CommonWidgets.convertTimeOfDay(
                          startTime,
                          p: startDate,
                        ).millisecondsSinceEpoch,
                        list: list,
                        isSelected: list.map((e) => false).toList(),
                      );
                      if (!isLoading) {
                        isLoading = true;
                        final msg = await manage.addTask(task);
                        print(msg);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));
                        await Future.delayed(Duration(seconds: 2));
                        if (msg == "Added") Navigator.pop(context);
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (list.indexOf(item) + 1).toString() +
                                        '. ' +
                                        item,
                                    style: TextStyle(fontSize: 19),
                                  ),
                                  IconButton(
                                    icon: Icon(CupertinoIcons.delete),
                                    onPressed: () {
                                      setState(() {
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

// class AddTaskAppBar extends StatelessWidget {
//   const AddTaskAppBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

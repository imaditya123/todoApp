import 'package:todo/add-task/addtask.dart';
import 'package:todo/add-task/edit-task.dart';
import 'package:todo/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/provider/provider.dart';

class Display extends StatelessWidget {
  const Display({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DisplayAppBar(),
            Consumer<Manager>(
              builder: (context, manage, _) => StreamBuilder<List<TaskModel>>(
                  stream: manage.getData,
                  initialData: [],
                  builder: (context, snapshot) {
                    final data = snapshot.requireData;
                    return Expanded(
                        child: ListView.builder(
                      itemCount: snapshot.data == null ? 0 : data.length,
                      itemBuilder: (context, index) {
                        return DisplayTile(task: data[index]);
                      },
                    ));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayTile extends StatefulWidget {
  DisplayTile({Key? key, required this.task}) : super(key: key);
  final TaskModel task;

  @override
  _DisplayTileState createState() => _DisplayTileState();
}

class _DisplayTileState extends State<DisplayTile> {
  var prog = 0.0;

  double calprogress() {
    int taskCompleted = 0;
    widget.task.isSelected.forEach((element) {
      if (element) taskCompleted++;
    });
    setState(() {
      prog = taskCompleted / widget.task.list.length;
    });
    return prog;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calprogress();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            enableDrag: true,
            backgroundColor: Colors.transparent,
            builder: (builder) {
              return new Container(
                color: Colors.transparent,
                child: new Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    height: (widget.task.list.length * 50) + 30,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(35.0),
                            topRight: const Radius.circular(35.0))),
                    child: ListView.builder(
                      itemCount: widget.task.list.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 50,
                          child: Row(
                            children: [
                              Checkbox(
                                  value: widget.task.isSelected[index],
                                  onChanged: (p) {
                                    final manage = Provider.of<Manager>(context,
                                        listen: false);
                                    widget.task.isSelected[index] = p ?? false;
                                    manage.editTask(widget.task);
                                    calprogress();
                                    Navigator.pop(context);
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Text(widget.task.list[index]),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
              );
            });
      },
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0xFFEAF9FE),
                  borderRadius: BorderRadius.circular(900),
                  border: Border.all(width: 1, color: Color(0xFF54AFC9))),
              child: CircularProgressIndicator(
                value: calprogress(),
                strokeWidth: 8,
                backgroundColor: Color(0xFFEAF9FE),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF63D3FA),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  CommonWidgets.convertToDay(widget.task.timestamp),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF9195A0)),
                ),
              ],
            ),
            Expanded(child: Container()),
            PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
              ),
              onSelected: (ind) {
                if (ind == 2) {
                  final manage = Provider.of<Manager>(context, listen: false);
                  manage.delete(widget.task);
                }
                if (ind == 1) {
                  CommonWidgets.push(context, EditTask(task: widget.task));
                }
              },
              itemBuilder: (context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  value: 1,
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('Delete'),
                ),
              ],
            ),
            // IconButton(
            //   onPressed: () {
            //     // final manage = Provider.of<Manager>(context, listen: false);
            //     // manage.delete(widget.task);
            //   },
            //   icon: Icon(Icons.more_vert),
            // ),
          ],
        ),
      ),
    );
  }
}

class DisplayAppBar extends StatelessWidget {
  const DisplayAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppBar().preferredSize.height,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xFFDEDEDE)))),
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(CommonWidgets.convertToDays(
                  DateTime.now().millisecondsSinceEpoch))),
          Expanded(
            child: Container(),
          ),
          // IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
          IconButton(
              onPressed: () {
                Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => AddTask(),
                      fullscreenDialog: true),
                );
              },
              icon: Icon(CupertinoIcons.add)),
        ],
      ),
    );
  }
}

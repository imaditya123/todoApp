import 'package:intl/intl.dart';
import 'package:todo/index.dart';

class CustomDatePicker extends StatefulWidget {
  Function(DateTime) changeDate;
  String text;
  bool isApp = false;

  DateTime minDate;
  DateTime maxDate;
  DateTime startDate;
  CustomDatePicker(
      {Key? key,
      required this.text,
      required this.minDate,
      required this.maxDate,
      this.isApp = false,
      required this.startDate,
      required this.changeDate})
      : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  void initState() {
    print(widget.startDate);
    if (widget.startDate != null) {
      _init = true;
      if (widget.isApp)
        dateT =
            DateFormat("EEE, MMM d, yyyy HH:mm aaa").format(widget.startDate);
      else
        dateT = DateFormat("EEE, MMM d, yyyy").format(widget.startDate);
    }
    super.initState();
  }

  var _init = false;
  static const int _bluePrimaryValue = 0xFF54D3C2;
  static const MaterialColor cyan = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(_bluePrimaryValue),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
  List<String> timeList = [
    "08:00",
    "08:15",
    "08:30",
    "08:45",
    "09:00",
    "09:15",
    "09:30",
    "09:45",
    "10:00",
    "10:15",
    "10:30",
    "10:45",
    "11:00",
    "11:15",
    "11:30",
    "11:45",
    "12:00",
    "12:15",
    "12:30",
    "12:45",
    "13:00",
    "13:15",
    "13:30",
    "13:45",
    "14:00",
    "14:15",
    "14:30",
    "14:45",
    "15:00",
    "15:15",
    "15:30",
    "15:45",
    "16:00",
    "16:15",
    "16:30",
    "16:45",
    "17:00"
  ];
  String dateT = "";

  Future<void> submit() async {
    final date = await showDatePicker(
        context: context,
        initialDate: !_init ? DateTime.now() : widget.startDate,
        firstDate: widget.minDate,
        lastDate: widget.maxDate,
        builder: (BuildContext context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: cyan,
                backgroundColor: AppColor.cyan,
                cardColor: AppColor.cyan,
                primaryColorDark: AppColor.cyan,
                accentColor: AppColor.cyan,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child == null ? Container() : child,
          );
        });

    if (date == null) return;

    var bottom;
    if (widget.isApp) {
      bottom = await showModalBottomSheet(
        // isScrollControlled: true,
        backgroundColor: AppColor.transparent,
        context: context,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 50,
                  height: 2,
                  // decoration: BoxDecoration(
                  //     color: AppColor.grey,
                  //     borderRadius: BorderRadius.circular(8)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: timeList.map(
                    (value) {
                      return InkWell(
                          onTap: () {
                            Navigator.pop(context, value);
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color:
                                            AppColor.grey.withOpacity(0.5)))),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              DateFormat("hh:mm aaa").format(
                                  DateTime.parse("1900-01-01").add(Duration(
                                      hours: int.parse(value.split(":")[0]),
                                      minutes:
                                          int.parse(value.split(":")[1])))),
                              style: TextStyle(fontSize: 20),
                            ),
                          ));
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (widget.isApp) {
      if (bottom == null) return;
      setState(() {
        widget.startDate = date.add(Duration(
            hours: int.parse(bottom.split(":")[0]),
            minutes: int.parse(bottom.split(":")[1])));

        dateT =
            DateFormat("EEE, MMM d, yyyy HH:mm aaa").format(widget.startDate);

        _init = true;
      });
    } else
      setState(() {
        widget.startDate = date;

        dateT = CommonWidgets.convertToDate(widget.startDate.toString());
        _init = true;
      });
    callDate(widget.startDate);
  }

  callDate(DateTime date) {
    widget.changeDate(date);
    // if (widget.text == "Date of Birth") {}
    // if (widget.text == "Tour Time") {}
    // if (widget.text == "Preffered Start Date") {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),

        Container(
          margin: const EdgeInsets.only(left: 2, right: 5),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          child: Text(
            widget.text,
            style: TextStyle(fontSize: 15),
          ),
        ),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.grey.withOpacity(0.1)),
            height: 45,
            padding: const EdgeInsets.only(left: 15),
            child: InkWell(
              onTap: submit,
              child: Row(
                children: [
                  Expanded(
                    child: Text(!_init ? widget.text : dateT,
                        style: TextStyle(
                            color: !_init ? AppColor.grey : Colors.black)),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: AppColor.grey,
                        size: 18,
                      ),
                      onPressed: submit),
                ],
              ),
            )),
      ],
    );
  }
}

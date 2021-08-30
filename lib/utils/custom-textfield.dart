import 'package:flutter/services.dart';
import 'package:todo/index.dart';
class CustomTextField extends StatelessWidget {
  final TextAlign textAlign;
  final String hint;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool isObscure;
   CustomTextField({
    Key ?key,
    required this.hint,required this.controller, this.isObscure=false, this.keyboardType=TextInputType.name, this.textAlign= TextAlign.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
      color: AppColor.grey.withOpacity(0.1)),
      height: 45,
      padding: const EdgeInsets.only(right: 35,left: 15),
      child: TextField(
        obscureText:isObscure ,
        inputFormatters: [
          LengthLimitingTextInputFormatter(150),
        ],
        cursorColor: AppColor.cyan,
        keyboardType: keyboardType,
       
        controller: controller,textAlign: textAlign,
        decoration: InputDecoration(
          // contentPadding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
      
          
          hintText: hint,
          hintStyle: TextStyle(
              color: AppColor.grey,
              fontSize: 14,
              fontWeight: FontWeight.w300),
          
          border: InputBorder.none,
        ),
      ),
    );
  }
}
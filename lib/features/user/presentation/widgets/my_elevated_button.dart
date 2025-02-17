import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  void Function()? onPressed;
  final String text;
  MyElevatedButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Color(0XFFFD4040),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        fixedSize: Size(MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).height * 0.07),
      ),
    );
  }
}

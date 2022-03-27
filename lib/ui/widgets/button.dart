import 'package:flutter/material.dart';

import '../theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function() onTap;

  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:onTap,
        child: Center(
          child: Container(
            width:100,
            height: 40,
            alignment: Alignment.center,
            decoration:BoxDecoration(
              borderRadius:BorderRadius.circular(15),
              color:primaryClr,
            ),
            child: Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign:TextAlign.center,
            ),
          ),
        ),
      );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../size_config.dart';
import '../theme.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     margin: EdgeInsets.only(top: 16),
      width: SizeConfig.screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.only(left: 13),
            width: SizeConfig.screenWidth,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[900],
                    readOnly: widget != null ? true : false,
                    autofocus: false,
                    style: subtitleStyle,
                    decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subtitleStyle,
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color:Get.isDarkMode?Colors.black:Colors.white,
                          width: 0,
                        )),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                        ))),
                  ),
                ),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
